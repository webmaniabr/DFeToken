import re
import hashlib
import base64
import json
import os
from Crypto.Cipher import AES
from time import time
from urllib.parse import urlencode

def create_secure_token_dfe(password, uuid):
    # Remove all non-numeric characters from the password
    password = re.sub(r'\D', '', password)
    
    # Generate the key using SHA-256
    key_source = f"{password}:{uuid}".encode('utf-8')
    key = hashlib.sha256(key_source).digest()
    
    # Generate the IV
    iv = os.urandom(AES.block_size)
    
    # Encrypt the current time as string
    cipher = AES.new(key, AES.MODE_CBC, iv)
    current_time = str(int(time())).encode('utf-8')
    current_time_padded = current_time + b' ' * (AES.block_size - len(current_time))
    encrypted_data = cipher.encrypt(current_time_padded)
    
    # Prepare the token data
    token_data = {
        'data': base64.b64encode(encrypted_data).decode('utf-8'),
        'iv': base64.b64encode(iv).decode('utf-8')
    }
    
    # Convert token data to JSON and then to URL-safe base64
    token_json = json.dumps(token_data)
    token_base64 = base64.urlsafe_b64encode(token_json.encode('utf-8')).decode('utf-8')
    
    return token_base64

password = '00.000.000/0000-00'  # CPF/CNPJ do tomador
uuid = '00000000-0000-0000-0000-000000000000'  # UUID da nota fiscal
key = '00000000000000000000000000000000000000000000'  # Chave da nota fiscal
token = create_secure_token_dfe(password, uuid)
url = f'https://nfe.webmaniabr.com/danfe/{key}/?token={token}'

print(url)
