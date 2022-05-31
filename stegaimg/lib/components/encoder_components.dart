import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/utilities/configs.dart';
import 'package:stegaimg/models/encode_model.dart';

/// Get Msg Size
///
/// @category Components: Encode
int getMsgSize(String msg){
  Uint16List byteMsg = msgToBytes(msg);
  return byteMsg.length * dataLength;
}

/// GetEncoderCapacity
///
/// @category Utilities
int getEncoderCapacity(Uint16List img) {
  return img.length;
}

/// Msg2Bytes
///
/// @category Utilities
Uint16List msgToBytes(String msg) {
  return Uint16List.fromList(msg.codeUnits);
}

/// Encode One Pixel
///
/// @category Components: Encode
int encodeOnePixel(int pixel, int msg) {
  if (msg != 1 && msg != 0) {
    throw FlutterError('msg_encode_bit_more_than_1_bit');
  }
  int lastBitMask = 254;
  int encoded = (pixel & lastBitMask) | msg;
  return encoded;
}

/// Pad Msg
///
/// @category Components: Encode
Uint16List padMsg(int capacity, Uint16List msg) {
  Uint16List padded = Uint16List(capacity);
  for (int i = 0; i < msg.length; ++i) {
    padded[i] = msg[i];
  }
  return padded;
}

/// Expand Msg
///
/// @category Components: Encode
Uint16List expandMsg(Uint16List msg) {
  Uint16List expanded = Uint16List(msg.length * dataLength);

  for (int i = 0; i < msg.length; ++i) {
    int msgByte = msg[i];
    for (int j = 0; j < dataLength; ++j) {
      int lastBit = msgByte & 1;
      expanded[i * dataLength + (dataLength - j - 1)] = lastBit;
      msgByte = msgByte >> 1;
    }
  }

  return expanded;
}

/// Convert Image To Data
///
/// @category Components: Encode
ImageConversionResponse convertImageToData(ImageConversionRequest req) {
  img_lib.Image? editableImage = img_lib.decodeImage(req.file!.readAsBytesSync());
  Image displayableImage = Image.file(req.file!, fit: BoxFit.fitWidth);
  int imageByteSize = getEncoderCapacity(Uint16List.fromList(editableImage!.getBytes().toList()));

  ImageConversionResponse response = ImageConversionResponse(
      editableImage, displayableImage, imageByteSize);
  return response;
}

/// Calculate Capacity Usage
///
/// @category Utilities
double calculateCapacityUsage(CapacityUsageRequest req) {
  String msg = req.msg;
  double encoderCapacity = req.imgBytes!.toDouble();
  double msgSize = msg.length.toDouble();
  return msgSize / encoderCapacity;
}
