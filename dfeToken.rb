require 'openssl'
require 'base64'
require 'json'
require 'cgi'

def create_secure_token_dfe(password, uuid)
  # Remove all non-numeric characters from the password
  password = password.gsub(/\D/, '')

  # Generate the key using SHA-256
  key_source = "#{password}:#{uuid}"
  key = OpenSSL::Digest::SHA256.digest(key_source)

  # Generate the IV
  iv = OpenSSL::Random.random_bytes(16)

  # Encrypt the current time
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv
  current_time = [Time.now.to_i].pack('Q>')
  encrypted_data = cipher.update(current_time) + cipher.final

  # Prepare the token data
  token_data = {
    data: Base64.strict_encode64(encrypted_data),
    iv: Base64.strict_encode64(iv)
  }

  # Convert token data to JSON and then to URL-safe base64
  token_json = token_data.to_json
  token_base64 = Base64.urlsafe_encode64(token_json)

  # URL encode the base64 string
  CGI.escape(token_base64)
end

password = '00.000.000/0000-00'  # CPF/CNPJ do tomador
uuid = '00000000-0000-0000-0000-000000000000'  # UUID da nota fiscal
key = '00000000000000000000000000000000000000000000'  # Chave da nota fiscal
token = create_secure_token_dfe(password, uuid)
url = "https://nfe.webmaniabr.com/danfe/#{key}/?token=#{token}"

puts url
