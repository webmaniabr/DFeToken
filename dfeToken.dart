import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';
import 'package:convert/convert.dart';

String createSecureTokenDfe(String password, String uuid) {
  password = password.replaceAll(RegExp(r'\D'), '');
  var keySource = utf8.encode('$password:$uuid');
  var key = sha256.convert(keySource).bytes;
  var iv = Uint8List.fromList(List<int>.generate(16, (i) => Random.secure().nextInt(256)));
  final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
    ..init(true, PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
        ParametersWithIV<KeyParameter>(KeyParameter(Uint8List.fromList(key)), iv), null));
  var currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var timeString = currentTime.toString();
  var timeBytes = utf8.encode(timeString);
  var encryptedData = cipher.process(Uint8List.fromList(timeBytes));
  var tokenData = {
    'data': base64.encode(encryptedData),
    'iv': base64.encode(iv),
  };
  var tokenJson = json.encode(tokenData);
  var tokenBase64 = base64Url.encode(utf8.encode(tokenJson));
  return tokenBase64;
}

void main() {
  String password = '00.000.000/0000-00';  // CPF/CNPJ do tomador
  String uuid = '00000000-0000-0000-0000-000000000000';  // UUID da nota fiscal
  String key = '00000000000000000000000000000000000000000000';  // Chave da nota fiscal

  String token = createSecureTokenDfe(password, uuid);
  String url = 'https://nfe.webmaniabr.com/danfe/$key/?token=$token';

  print(url);
}

