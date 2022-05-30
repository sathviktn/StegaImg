import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/utilities/configs.dart';
import 'package:stegaimg/models/encode_model.dart';


/// GetMsgSize
int getMsgSize(String msg){
  Uint16List byteMsg = msg2Bytes(msg);
  return byteMsg.length * dataLength;
}

/// EncodeOnePixel
int encodeOnePixel(int pixel, int msg) {
  if (msg != 1 && msg != 0) {
    throw FlutterError('msg_encode_bit_more_than_1_bit');
  }
  int lastBitMask = 254;
  int encoded = (pixel & lastBitMask) | msg;
  return encoded;
}

/// PadMsg
Uint16List padMsg(int capacity, Uint16List msg) {
  Uint16List padded = Uint16List(capacity);
  for (int i = 0; i < msg.length; ++i) {
    padded[i] = msg[i];
  }
  return padded;
}

/// ExpandMsg
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

/// ConvertUploadedImageToData
UploadedImageConversionResponse convertUploadedImageToData(UploadedImageConversionRequest req) {
  img_lib.Image? editableImage = img_lib.decodeImage(req.file!.readAsBytesSync());
  Image displayableImage = Image.file(req.file!, fit: BoxFit.fitWidth);
  int imageByteSize = getEncoderCapacity(Uint16List.fromList(editableImage!.getBytes().toList()));

  UploadedImageConversionResponse response = UploadedImageConversionResponse(
      editableImage, displayableImage, imageByteSize);
  return response;
}
