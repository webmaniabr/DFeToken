import re
import hashlib
import base64
import json
import os
from Crypto.Cipher import AES
from time import time
from urllib import quote as urlencode

def create_secure_token_dfe(password, uuid):
    password = re.sub(r'\D', '', password)
    key_source = "{}:{}".format(password, uuid)
    key = hashlib.sha256(key_source.encode('utf-8')).digest()
    iv = os.urandom(AES.block_size)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    current_time = str(int(time())).encode('utf-8')
    padding_length = AES.block_size - len(current_time)
    current_time_padded = current_time + b' ' * padding_length
    encrypted_data = cipher.encrypt(current_time_padded)
    token_data = {
        'data': base64.b64encode(encrypted_data),
        'iv': base64.b64encode(iv)
    }
    token_json = json.dumps(token_data)
    token_base64 = base64.urlsafe_b64encode(token_json.encode('utf-8'))
    return urlencode(token_base64)

password = '00.000.000/0000-00'  # CPF/CNPJ do tomador
uuid = '00000000-0000-0000-0000-000000000000'  # UUID da nota fiscal
key = '00000000000000000000000000000000000000000000'  # Chave da nota fiscal
token = create_secure_token_dfe(password, uuid)
url = 'https://nfe.webmaniabr.com/danfe/{}/?token={}'.format(key, token)

print(url)
