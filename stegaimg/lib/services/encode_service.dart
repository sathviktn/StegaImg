import 'package:encrypt/encrypt.dart' as crypto;
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/utilities/configs.dart';
import 'package:stegaimg/models/encode_model.dart';
import 'package:stegaimg/components/encoder_components.dart';



/// Encode Message Into Image
///
/// Summary: To encode input message into the input image.
EncodeResponse encodeMessageIntoImage(EncodeRequest? req)  {
  // Get inputs
  Uint16List img = Uint16List.fromList(req!.originalImg.getBytes().toList());
  String msg = req.secretMsg;
  String? password = req.password;

  // if user wants to encrypt with password
  if (req.shouldEncrypt())
  {
    crypto.Key key = crypto.Key.fromUtf8(padCryptionKey(password!));
    crypto.IV iv = crypto.IV.fromLength(16);

    crypto.Encrypter encrypter = crypto.Encrypter(crypto.AES(key));
    crypto.Encrypted encrypted = encrypter.encrypt(msg, iv: iv);
    msg = encrypted.base64;
  }

  // check if image capacity less than msg size
  if (getEncoderCapacity(img) < getMsgSize(msg)) {
    throw FlutterError('image_capacity_not_enough');
  }

  Uint16List expandedMsg = expandMsg(msg2Bytes(msg));
  Uint16List paddedMsg = padMsg(getEncoderCapacity(img), expandedMsg);

  // check if padded msg size and original msg size matches
  if (getEncoderCapacity(paddedMsg) != getEncoderCapacity(img)) {
    throw FlutterError('msg_container_size_not_match');
  }

  // encode pixel by pixel
  Uint16List encodedImg = img;
  for (int i = 0; i < getEncoderCapacity(img); ++i) {
    encodedImg[i] = encodeOnePixel(img[i], paddedMsg[i]);
  }

  // encoded editable image
  img_lib.Image editableImage = img_lib.Image.fromBytes(
      req.originalImg.width, req.originalImg.height, encodedImg.toList()
  );

  // encoded display image widget
  Image displayImage = Image.memory(
      img_lib.encodePng(editableImage) as Uint8List,
      fit: BoxFit.fitWidth
  );

  // encoded Uint8List data
  Uint8List data = Uint8List.fromList(img_lib.encodePng(editableImage));

  EncodeResponse response = EncodeResponse(editableImage, displayImage, data, req.imgName);
  return response;
}

