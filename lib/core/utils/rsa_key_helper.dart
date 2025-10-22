import 'dart:convert';
import 'dart:math';
import "package:asn1lib/asn1lib.dart";
import 'package:sat_sen_app/core/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import "package:pointycastle/export.dart";

enum AsymBlockCipherToUse { rsa, pkcs1, oaep }

/// Helper class to handle RSA key generation and encoding
class RsaKeyHelper {
  static const BEGIN_PRIVATE_KEY = '-----BEGIN PRIVATE KEY-----';
  static const END_PRIVATE_KEY = '-----END PRIVATE KEY-----';

  static const BEGIN_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----';
  static const END_PUBLIC_KEY = '-----END PUBLIC KEY-----';

  static const BEGIN_EC_PRIVATE_KEY = '-----BEGIN EC PRIVATE KEY-----';
  static const END_EC_PRIVATE_KEY = '-----END EC PRIVATE KEY-----';

  static const BEGIN_EC_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----';
  static const END_EC_PUBLIC_KEY = '-----END PUBLIC KEY-----';

  static const BEGIN_RSA_PRIVATE_KEY = '-----BEGIN RSA PRIVATE KEY-----';
  static const END_RSA_PRIVATE_KEY = '-----END RSA PRIVATE KEY-----';

  static const BEGIN_RSA_PUBLIC_KEY = '-----BEGIN RSA PUBLIC KEY-----';
  static const END_RSA_PUBLIC_KEY = '-----END RSA PUBLIC KEY-----';

  static final _byteMask = BigInt.from(0xff);

  /// Generate a [PublicKey] and [PrivateKey] pair
  ///
  /// Returns a [AsymmetricKeyPair] based on the [RSAKeyGenerator] with custom parameters,
  /// including a [SecureRandom]
  Future<AsymmetricKeyPair<PublicKey, PrivateKey>> computeRSAKeyPair(
    SecureRandom secureRandom,
  ) async {
    return await compute(getRsaKeyPair, secureRandom);
  }

  /// Generates a [SecureRandom]
  ///
  /// Returns [FortunaRandom] to be used in the [AsymmetricKeyPair] generation
  SecureRandom getSecureRandom() {
    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  /// Decode Public key from PEM Format
  ///
  /// Given a base64 encoded PEM [String] with correct headers and footers, return a
  /// [RSAPublicKey]
  ///
  /// *PKCS1*
  /// RSAPublicKey ::= SEQUENCE {
  ///    modulus           INTEGER,  -- n
  ///    publicExponent    INTEGER   -- e
  /// }
  ///
  /// *PKCS8*
  /// PublicKeyInfo ::= SEQUENCE {
  ///   algorithm       AlgorithmIdentifier,
  ///   PublicKey       BIT STRING
  /// }
  ///
  /// AlgorithmIdentifier ::= SEQUENCE {
  ///   algorithm       OBJECT IDENTIFIER,
  ///   parameters      ANY DEFINED BY algorithm OPTIONAL
  /// }
  RSAPublicKey parsePublicKeyFromPem(pemString) {
    List<int> publicKeyDER = decodePEM(pemString);
    var asn1Parser = ASN1Parser(publicKeyDER as Uint8List);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    ASN1Integer modulus, exponent;
    // Depending on the first element type, we either have PKCS1 or 2
    if (topLevelSeq.elements[0].runtimeType == ASN1Integer) {
      modulus = topLevelSeq.elements[0] as ASN1Integer;
      exponent = topLevelSeq.elements[1] as ASN1Integer;
    } else {
      var publicKeyBitString = topLevelSeq.elements[1];

      var publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes());
      ASN1Sequence publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
      modulus = publicKeySeq.elements[0] as ASN1Integer;
      exponent = publicKeySeq.elements[1] as ASN1Integer;
    }

    RSAPublicKey rsaPublicKey = RSAPublicKey(
      modulus.valueAsBigInteger,
      exponent.valueAsBigInteger,
    );

    return rsaPublicKey;
  }

  /// Sign plain text with Private Key
  ///
  /// Given a plain text [String] and a [RSAPrivateKey], decrypt the text using
  /// a [RSAEngine] cipher
  String sign(String plainText, RSAPrivateKey privateKey) {
    var signer = RSASigner(SHA256Digest(), "0609608648016503040201");
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    return base64Encode(
      signer.generateSignature(createUint8ListFromString(plainText)).bytes,
    );
  }

  /// Creates a [Uint8List] from a string to be signed
  Uint8List createUint8ListFromString(String s) {
    var codec = Utf8Codec(allowMalformed: true);
    return Uint8List.fromList(codec.encode(s));
  }

  /// Decode Private key from PEM Format
  ///
  /// Given a base64 encoded PEM [String] with correct headers and footers, return a
  /// [RSAPrivateKey]
  RSAPrivateKey parsePrivateKeyFromPem(pemString) {
    List<int> privateKeyDER = decodePEM(pemString);
    var asn1Parser = ASN1Parser(privateKeyDER as Uint8List);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    ASN1Integer modulus, privateExponent, p, q;
    // Depending on the number of elements, we will either use PKCS1 or PKCS8
    if (topLevelSeq.elements.length == 3) {
      var privateKey = topLevelSeq.elements[2];

      asn1Parser = ASN1Parser(privateKey.contentBytes());
      var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

      modulus = pkSeq.elements[1] as ASN1Integer;
      privateExponent = pkSeq.elements[3] as ASN1Integer;
      p = pkSeq.elements[4] as ASN1Integer;
      q = pkSeq.elements[5] as ASN1Integer;
    } else {
      modulus = topLevelSeq.elements[1] as ASN1Integer;
      privateExponent = topLevelSeq.elements[3] as ASN1Integer;
      p = topLevelSeq.elements[4] as ASN1Integer;
      q = topLevelSeq.elements[5] as ASN1Integer;
    }

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
      modulus.valueAsBigInteger,
      privateExponent.valueAsBigInteger,
      p.valueAsBigInteger,
      q.valueAsBigInteger,
    );

    return rsaPrivateKey;
  }

  List<int> decodePEM(String pem) {
    return base64.decode(removePemHeaderAndFooter(pem));
  }

  String removePemHeaderAndFooter(String pem) {
    var startsWith = [
      "-----BEGIN PUBLIC KEY-----",
      "-----BEGIN RSA PRIVATE KEY-----",
      "-----BEGIN RSA PUBLIC KEY-----",
      "-----BEGIN PRIVATE KEY-----",
      "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
      "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    ];
    var endsWith = [
      "-----END PUBLIC KEY-----",
      "-----END PRIVATE KEY-----",
      "-----END RSA PRIVATE KEY-----",
      "-----END RSA PUBLIC KEY-----",
      "-----END PGP PUBLIC KEY BLOCK-----",
      "-----END PGP PRIVATE KEY BLOCK-----",
    ];
    bool isOpenPgp = pem.contains('BEGIN PGP');

    pem = pem.replaceAll(' ', '');
    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    for (var s in startsWith) {
      s = s.replaceAll(' ', '');
      if (pem.startsWith(s)) {
        pem = pem.substring(s.length);
      }
    }

    for (var s in endsWith) {
      s = s.replaceAll(' ', '');
      if (pem.endsWith(s)) {
        pem = pem.substring(0, pem.length - s.length);
      }
    }

    if (isOpenPgp) {
      var index = pem.indexOf('\r\n');
      pem = pem.substring(0, index);
    }

    return pem;
  }

  /// Encode Private key to PEM Format
  ///
  /// Given [RSAPrivateKey] returns a base64 encoded [String] with standard PEM headers and footers
  Future<String> encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
    var topLevel = ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n!);
    var publicExponent = ASN1Integer(privateKey.exponent!);
    var privateExponent = ASN1Integer(privateKey.d!);
    var p = ASN1Integer(privateKey.p!);
    var q = ASN1Integer(privateKey.q!);
    var dP = privateKey.privateExponent! % (privateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.privateExponent! % (privateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q!.modInverse(privateKey.p!);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encodedBytes);

    return Future.value(
      """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""",
    );
  }

  ///
  /// Enode the given [publicKey] to PEM format using the PKCS#8 standard.
  ///
  Future<String> encodeRSAPublicKeyToPemPKCS8(RSAPublicKey publicKey) {
    var algorithmSeq = ASN1Sequence();
    var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(
      ASN1ObjectIdentifier.fromComponentString("1.2.840.113549.1.1.1"),
    );
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus!));
    publicKeySeq.add(ASN1Integer(publicKey.exponent!));
    var publicKeySeqBitString = ASN1BitString(
      Uint8List.fromList(publicKeySeq.encodedBytes),
    );

    var topLevelSeq = ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);
    var chunks = StringUtils.chunk(dataBase64, 64);

    return Future.value(
      '$BEGIN_PUBLIC_KEY\n${chunks.join('\n')}\n$END_PUBLIC_KEY',
    );
  }

  /// Encode Public key to PEM Format
  ///
  /// Given [RSAPublicKey] returns a base64 encoded [String] with standard PEM headers and footers
  String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
    var topLevel = ASN1Sequence();

    topLevel.add(ASN1Integer(publicKey.modulus!));
    topLevel.add(ASN1Integer(publicKey.exponent!));

    var dataBase64 = base64.encode(topLevel.encodedBytes);
    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  Uint8List rsaDecrypt(
    RSAPrivateKey myPrivate,
    Uint8List cipherText,
    AsymBlockCipherToUse scheme,
  ) {
    var decryptor = _createBlockCipher(scheme);

    decryptor.init(
      false,
      PrivateKeyParameter<RSAPrivateKey>(myPrivate),
    ); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  AsymmetricBlockCipher _createBlockCipher(AsymBlockCipherToUse scheme) {
    switch (scheme) {
      case AsymBlockCipherToUse.rsa:
        return RSAEngine();
      case AsymBlockCipherToUse.pkcs1:
        return PKCS1Encoding(RSAEngine());
      case AsymBlockCipherToUse.oaep:
        return OAEPEncoding(RSAEngine());
    }
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks =
        input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
        input,
        inputOffset,
        chunkSize,
        output,
        outputOffset,
      );

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }
}

/// Generate a [PublicKey] and [PrivateKey] pair
///
/// Returns a [AsymmetricKeyPair] based on the [RSAKeyGenerator] with custom parameters,
/// including a [SecureRandom]
AsymmetricKeyPair<PublicKey, PrivateKey> getRsaKeyPair(
  SecureRandom secureRandom,
) {
  var rsapars = RSAKeyGeneratorParameters(BigInt.from(65537), 1024, 5);
  var params = ParametersWithRandom(rsapars, secureRandom);
  var keyGenerator = RSAKeyGenerator();
  keyGenerator.init(params);
  return keyGenerator.generateKeyPair();
}
