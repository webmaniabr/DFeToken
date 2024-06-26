import re
import hashlib
import base64
import json
import os
from Crypto.Cipher import AES
from time import time
from urllib import quote as urlencode

def create_secure_token_dfe(password, uuid):
    # Remove all non-numeric characters from the password
    password = re.sub(r'\D', '', password)

    # Generate the key using SHA-256
    key_source = "{}:{}".format(password, uuid).encode('utf-8')
    key = hashlib.sha256(key_source).digest()

    # Generate the IV
    iv = os.urandom(AES.block_size)

    # Encrypt the current time
    cipher = AES.new(key, AES.MODE_CBC, iv)
    current_time = int(time()).to_bytes(AES.block_size, 'big')
    encrypted_data = cipher.encrypt(current_time)

    # Prepare the token data
    token_data = {
        'data': base64.b64encode(encrypted_data),
        'iv': base64.b64encode(iv)
    }

    # Convert token data to JSON and then to URL-safe base64
    token_json = json.dumps(token_data)
    token_base64 = base64.b64encode(token_json.encode('utf-8'))

    # URL encode the base64 string
    return urlencode(token_base64)

password = '00.000.000/0000-00'  # CPF/CNPJ do tomador
uuid = '00000000-0000-0000-0000-000000000000'  # UUID da nota fiscal
key = '00000000000000000000000000000000000000000000'  # Chave da nota fiscal
token = create_secure_token_dfe(password, uuid)
url = 'https://nfe.webmaniabr.com/danfe/{}/?token={}'.format(key, token)

print(url)
