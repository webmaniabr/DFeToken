<?php 

function createSecureTokenDFe( $password, $uuid ){

  $password = preg_replace("/[^0-9]/", '', $password);
  $key = hash('sha256', $password . ':' . $uuid, true);
  $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('AES-256-CBC'));
  $encryptedData = openssl_encrypt(time(), 'AES-256-CBC', $key, OPENSSL_RAW_DATA, $iv);
  $tokenData = json_encode(['data' => base64_encode($encryptedData), 'iv' => base64_encode($iv)]);
  return urlencode(base64_encode($tokenData));

}

$password = '00.000.000/0000-00'; // CPF/CNPJ do tomador
$uuid = '00000000-0000-0000-0000-000000000000'; // UUID da nota fiscal
$key = '00000000000000000000000000000000000000000000'; // Chave da nota fiscal
$url = 'https://nfe.webmaniabr.com/danfe/' . $key . '/?token='.createSecureTokenDFe( $password, $uuid );

?>