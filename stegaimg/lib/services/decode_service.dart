import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:stegaimg/models/decode_model.dart';
import 'package:stegaimg/components/decoder_components.dart';
import 'package:stegaimg/utilities/configs.dart';

/// Decode Message From Image
///
/// To decode message from the input image.
///
/// @category Services
DecodeResponse decodeMessageFromImage(DecodeRequest? req){
  // Get inputs
  Uint16List img = Uint16List.fromList(req!.original!.getBytes().toList());
  Uint16List extracted = extractBitsFromImg(img); //img
  Uint16List padded = padToBytes(extracted);
  Uint16List byteMsg = bitsToBytes(padded);
  Uint16List sanitized = sanitizePaddingZeros(byteMsg);
  String msg = bytesToMsg(sanitized);
  String? password = req.password;

  if (req.shouldDecrypt()) {
    crypto.Key key = crypto.Key.fromUtf8(padCryptionKey(password!));
    crypto.IV iv = crypto.IV.fromLength(16);
    crypto.Encrypter encrypter = crypto.Encrypter(crypto.AES(key));
    crypto.Encrypted encryptedMsg = crypto.Encrypted.fromBase64(msg);
    msg = encrypter.decrypt(encryptedMsg, iv: iv);
  }

  DecodeResponse response = DecodeResponse(msg);
  return response;
}