import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:basic_utils/basic_utils.dart';

String getPublicKeyString(AsymmetricKeyPair<PublicKey, PrivateKey> keyPair) {
  final pem = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(
      keyPair.publicKey as RSAPublicKey);
  final lines = LineSplitter.split(pem)
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  return lines.sublist(1, lines.length - 1).join('');
}

String getPrivateKeyString(AsymmetricKeyPair<PublicKey, PrivateKey> keyPair) {
  final pem = CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(
      keyPair.privateKey as RSAPrivateKey);
  final lines = LineSplitter.split(pem)
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  return lines.sublist(1, lines.length - 1).join('');
}

Future<String> getMD5(List<int> file) async {
  return md5.convert(file).toString();
}
