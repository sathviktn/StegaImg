import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Configs
const int byteSize = 8;
const int byteCount = 2;
const int dataLength = byteSize * byteCount;

/// Msg2Bytes
Uint16List msg2Bytes(String msg) {
  return Uint16List.fromList(msg.codeUnits);
}

/// GetMsgSize
int getMsgSize(String msg){
  Uint16List byteMsg = msg2Bytes(msg);
  return byteMsg.length * dataLength;
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

/// PadMsg
Uint16List padMsg(int capacity, Uint16List msg) {
  Uint16List padded = Uint16List(capacity);
  for (int i = 0; i < msg.length; ++i) {
    padded[i] = msg[i];
  }
  return padded;
}

/// GetEncoderCapacity
int getEncoderCapacity(Uint16List img) {
  return img.length;
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

/// Result State
///
/// {@category Services: States}
enum ResultState {
  success,
  error
}

/// Loading State
///
/// {@category Services: States}
enum LoadingState {
  LOADING,
  ERROR,
  PENDING,
  SUCCESS,
}


/// Capacity Usage Request
///
/// {@category Services: Requests}
class CapacityUsageRequest {
  int? imgBytes;
  String msg;

  CapacityUsageRequest(this.msg, this.imgBytes);
}


double calculateCapacityUsage(CapacityUsageRequest req) {
  String msg = req.msg;
  double encoderCapacity = req.imgBytes!.toDouble();
  double msgSize = msg.length.toDouble();
  return msgSize / encoderCapacity;
}

Future<double> calculateCapacityUsageAsync(CapacityUsageRequest req) async {
  double usage = await compute(calculateCapacityUsage, req);
  return usage;
}


