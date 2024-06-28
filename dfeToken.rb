require 'openssl'
require 'base64'
require 'json'
require 'cgi'

def create_secure_token_dfe(password, uuid)
  password = password.gsub(/\D/, '')
  key_source = "#{password}:#{uuid}"
  key = OpenSSL::Digest::SHA256.digest(key_source)
  iv = OpenSSL::Random.random_bytes(16)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv
  current_time = Time.now.to_i.to_s
  encrypted_data = cipher.update(current_time) + cipher.final
  token_data = {
    data: Base64.strict_encode64(encrypted_data),
    iv: Base64.strict_encode64(iv)
  }
  token_json = token_data.to_json
  token_base64 = Base64.urlsafe_encode64(token_json)
  CGI.escape(token_base64)
end

password = '00.000.000/0000-00'  # CPF/CNPJ do tomador
uuid = '00000000-0000-0000-0000-000000000000'  # UUID da nota fiscal
key = '00000000000000000000000000000000000000000000'  # Chave da nota fiscal
token = create_secure_token_dfe(password, uuid)
url = "https://nfe.webmaniabr.com/danfe/#{key}/?token=#{token}"

puts url
