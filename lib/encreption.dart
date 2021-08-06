import 'package:encrypt/encrypt.dart' as encrept;

class Encreption {
  static final key = encrept.Key.fromLength(32);
  static final iv = encrept.IV.fromLength(16);
  static final encreptor = encrept.Encrypter(encrept.AES(key));

  static encreptAES(text) {
    final encrept = encreptor.encrypt(text, iv: iv);
    return encrept.base64;
  }

  static decreptAES(text) {
    final decrept =
        encreptor.decrypt(encrept.Encrypted.fromBase64(text), iv: iv);
    return decrept;
  }
}
