import 'package:flutter/material.dart';

const int byteSize = 8;
const int byteCount = 2;

/// Configs
///
/// @category Utilities: Configs
const int dataLength = byteSize * byteCount;

/// Result State
///
/// @category Utilities: States
enum ResultState {
  success,
  error
}

/// Loading State
///
/// @category Utilities: States
enum LoadingState {
  loading,
  error,
  pending,
  success,
}

/// Get SnackBar
///
/// @category Utilities: SnackBar
SnackBar getSnackBar(IconData icon, Color clr, String snackText) =>
    SnackBar(
        backgroundColor: clr,
        content: Row(
          children: [
            Icon(icon, size: 50,),
            const SizedBox(width: 20,),
            Expanded(child: Text(snackText,
                style: const StegaImgTextStyle(
                    fColor: Colors.black, fWeight: FontWeight.bold,
                  fSize: 25, fStyle: FontStyle.italic
                )
            )
            )
          ]
    )
);

/// Pad Cryption Key
///
/// To pad the input password to 32 digit length key.
///
/// @category Utilities
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

/// Custom TextStyle for StegaImg
///
/// @category Utilities: TextStyle
class StegaImgTextStyle extends TextStyle {
  final String fFamily;
  final double fSize;
  final Color fColor;
  final FontWeight fWeight;
  final FontStyle fStyle;
  final double lSpacing;

  const StegaImgTextStyle({
    this.fFamily = 'JosefinSans',
    this.fSize = 20,
    this.fColor = Colors.white,
    this.fWeight = FontWeight.w500,
    this.fStyle = FontStyle.normal,
    this.lSpacing = 1.0

  }) : super(
    color: fColor,
    fontWeight: fWeight,
    fontSize: fSize,
    fontStyle: fStyle,
    fontFamily: fFamily,
    letterSpacing: lSpacing
  );
}
