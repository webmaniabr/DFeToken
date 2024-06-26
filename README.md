<p align="center">
  <img src="https://wmbr.s3.amazonaws.com/img/logo_webmaniabr_github2.png">
</p>

# Token para acesso do XML/PDF sem senha - DFeToken

Conforme as regras da LGPD e para a segurança das informações sensíveis dos documentos fiscais, após o período de 24 horas ou após o primeiro acesso público, são aplicadas restrições de acesso aos arquivos XML e PDF conforme a documentação.

- NF-e/NFC-e: https://webmaniabr.com/docs/rest-api-nfe/#download-xml-pdf
- NFS-e:  https://webmaniabr.com/docs/rest-api-nfse/#download-xml-pdf
- MDF-e: https://webmaniabr.com/docs/rest-api-mdfe/#download-xml-pdf
- CT-e: https://webmaniabr.com/docs/rest-api-cte/#download-xml-pdf

# Acesso via Token

Para disponibilizar o link do PDF e XML com segurança e eliminar a exigência da senha, é necessário a geração do token de forma criptografada utilizando a camada de segurança AES-256-CBC. Após gerar o token, deve ser enviado na URL do arquivo. Segue exemplo: https://nfe.webmaniabr.com/danfe/[CHAVE]/?token=[TOKEN]. 

# Passo a passo

1. **Coleta de dados:** No banco de dados do seu sistema, colete a informação da senha (CPF/CNPJ do tomador de nota fiscal) e a UUID (retornada pela API da Webmania) do documento fiscal.
2. **Geração do token:** Utilize a função fornecida para gerar o token criptografado e inseri-lo na URL do documento fiscal.
3. **URL com token:** Informe ao seu cliente a URL com o token: https://nfe.webmaniabr.com/danfe/[CHAVE]/?token=[TOKEN].
4. **Validação do token**: A Webmania identifica o token e valida sua autenticidade com base na criptografia.
5. **Acesso:** O documento fiscal é disponibilizado sem a exigência de senha.

# Segurança do Token

- **Validade**: O token é válido por 24 horas e criptografado na camada de segurança AES-256-CBC. Caso o cliente compartilhe o link ou a URL seja exposta, as informações estarão protegidas.
- **Criação Rápida:** A criação do token é rápida e não exige processamento dos seus servidores, podendo ser gerado toda vez que o cliente carregar a página, resultando em links dinâmicos e sempre renovados.

# Compromisso com a segurança

Na Webmania, a segurança da informação é nossa prioridade máxima. Valorizamos a proteção de todas as informações sensíveis contidas nos documentos fiscais, garantindo a segurança tanto do emissor quanto do tomador da nota fiscal. Implementamos rigorosas medidas de segurança, como a criptografia avançada, para assegurar que os dados pessoais e empresariais estejam sempre protegidos contra acessos não autorizados e fraudes. Nosso compromisso é proporcionar um ambiente seguro e confiável para todos os nossos clientes.
