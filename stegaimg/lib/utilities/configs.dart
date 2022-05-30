import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Configs
const int byteSize = 8;
const int byteCount = 2;
const int dataLength = byteSize * byteCount;

/// Msg2Bytes
Uint16List msg2Bytes(String msg) {
  return Uint16List.fromList(msg.codeUnits);
}

/// Bytes2Msg
String bytes2msg(Uint16List bytes) {
//  List<int> list = bytes.toString().codeUnits;
  //bytes = Uint16List.fromList(list);
  return String.fromCharCodes(bytes);
}

/// GetEncoderCapacity
int getEncoderCapacity(Uint16List img) {
  return img.length;
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


SnackBar getSnackBar(IconData icon, Color clr, String snackText) => SnackBar(
    backgroundColor: clr,
    content: Row(
      children: [
        Icon(icon, size: 50,),
        const SizedBox(width: 20,),
        Expanded(child: Text(snackText,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'JosefinSans',
                fontSize: 25,
            )
        )
        )]
    )
);

/// PadCryptionKey
///
/// Summary: To pad the input password to 32 digit length key.
String padCryptionKey(String key) {
  if (key.length > 32) {
    throw FlutterError('cryption_key_length_greater_than_32');
  }

  String paddedKey = key;
  int padCnt = 32 - key.length;

  for (int i = 0; i < padCnt; ++i) {
    paddedKey += '.';
  }
  return paddedKey;
}

class StegaTextStyle extends TextStyle {
  final String fFamily;
  final double fSize;
  final Color fColor;
  final FontWeight fWeight;
  final FontStyle fStyle;

  const StegaTextStyle({
    this.fFamily = 'JosefinSans',
    this.fSize = 20,
    this.fColor = Colors.white,
    this.fWeight = FontWeight.w500,
    this.fStyle = FontStyle.normal
  }) : super(
    color: fColor,
    fontWeight: fWeight,
    fontSize: fSize,
    fontStyle: fStyle,
    fontFamily: fFamily,
  );
}

class StegaInputDec extends InputDecoration{
  final String hint;
  final double hFontSize;

  StegaInputDec({
    // default values
    this.hint = "hint",
    this.hFontSize = 20
  }) : super(
    hintText: hint,
    hintStyle: StegaTextStyle(fSize: hFontSize),
  );
}


