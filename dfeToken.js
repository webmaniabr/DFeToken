async function createSecureTokenDFe(password, uuid) {
  const numericPassword = String(password).replace(/[^0-9]/g, '');
  const dataToHash = `${numericPassword}:${uuid}`;

  const encoder = new TextEncoder();
  const hash = await crypto.subtle.digest('SHA-256', encoder.encode(dataToHash));
  const key = await crypto.subtle.importKey('raw', hash, { name: 'AES-CBC' }, false, ['encrypt']);

  const iv = crypto.getRandomValues(new Uint8Array(16));
  const nowSeconds = Math.floor(Date.now() / 1000).toString();

  const encrypted = await crypto.subtle.encrypt(
    { name: 'AES-CBC', iv },
    key,
    encoder.encode(nowSeconds)
  );

  const tokenData = JSON.stringify({
    data: toBase64(encrypted),
    iv: toBase64(iv),
  });

  return encodeURIComponent(btoa(tokenData));
}

function toBase64(input) {
  const bytes = input instanceof Uint8Array ? input : new Uint8Array(input);
  let binary = '';
  for (let i = 0; i < bytes.length; i++) binary += String.fromCharCode(bytes[i]);
  return btoa(binary);
}

(async () => {
  const password = '00.000.000/0000-00'; // CPF/CNPJ do tomador
  const uuid = '00000000-0000-0000-0000-000000000000'; // UUID da nota fiscal
  const chaveDaNota = '00000000000000000000000000000000000000000000'; // Chave da nota fiscal

  const token = await createSecureTokenDFe(password, uuid);
  const url = `https://nfe.webmaniabr.com/danfe/${chaveDaNota}/?token=${token}`;
})();
