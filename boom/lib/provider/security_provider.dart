import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:boom/provider/configure_provider.dart';
import 'package:boom/utils/rsa.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_provider.g.dart';

// RSA加密块大小
const int _rsaEncryptBlock = 117;
// RSA解密块大小
const int _rsaDecryptBlock = 128;

@riverpod
class Security extends _$Security {
  late RSAPrivateKey _privateKey;
  @override
  void build() {
    var config = ref.watch(configureProvider);
    var privateKeyString = config.privateKey;
    try {
      _privateKey = _privateKeyFromPem(privateKeyString);
      _publicKeyFromPem(config.publicKey);
    } catch (e) {
      var keyPair = CryptoUtils.generateRSAKeyPair(keySize: 1024);
      ref
          .read(configureProvider.notifier)
          .updatePublicKey(getPublicKeyString(keyPair));
      ref
          .read(configureProvider.notifier)
          .updatePrivateKey(getPrivateKeyString(keyPair));
      _privateKey = keyPair.privateKey as RSAPrivateKey;
    }
  }

  List<int> encrypt(String message, String publicKeyString) {
    var publicKey = _publicKeyFromPem(publicKeyString);
    var sourceBytes = message.codeUnits;
    int inputLen = sourceBytes.length;
    List<int> totalBytes = [];
    for (var i = 0; i < inputLen; i += _rsaEncryptBlock) {
      // 还剩多少字节长度
      int endLen = inputLen - i;
      List<int> item;
      if (endLen > _rsaEncryptBlock) {
        item = sourceBytes.sublist(i, i + _rsaEncryptBlock);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }

      var cipher = RSAEngine()
        ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
      totalBytes.addAll(cipher.process(Uint8List.fromList(item)));
    }
    return totalBytes;
  }

  String? decrypt(List<int> sourceBytes) {
    try {
      int inputLen = sourceBytes.length;
      List<int> totalBytes = [];
      for (var i = 0; i < inputLen; i += _rsaDecryptBlock) {
        int endLen = inputLen - i;
        List<int> item;
        if (endLen > _rsaDecryptBlock) {
          item = sourceBytes.sublist(i, i + _rsaDecryptBlock);
        } else {
          item = sourceBytes.sublist(i, i + endLen);
        }
        var cipher = RSAEngine()
          ..init(false, PrivateKeyParameter<RSAPrivateKey>(_privateKey));
        totalBytes.addAll(cipher.process(Uint8List.fromList(item)));
      }
      return utf8.decode(totalBytes);
    } catch (e) {
      print(e);
      return null;
    }
  }

  RSAPublicKey _publicKeyFromPem(String publicKeyString) {
    final t =
        CryptoUtils.getBytesFromPEMString(publicKeyString, checkHeader: false);
    return CryptoUtils.rsaPublicKeyFromDERBytesPkcs1(t);
  }

  RSAPrivateKey _privateKeyFromPem(String publicKeyString) {
    final t =
        CryptoUtils.getBytesFromPEMString(publicKeyString, checkHeader: false);
    return CryptoUtils.rsaPrivateKeyFromDERBytesPkcs1(t);
  }
}
