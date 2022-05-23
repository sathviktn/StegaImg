import 'package:image/image.dart' as img_lib;
import 'package:flutter/widgets.dart';
import 'dart:typed_data';
import 'package:stegaimg/utilities/configs.dart';

/// Encode Response
class EncodeResponse {
  img_lib.Image editableImage;   // not needed
  Image displayImage;  // for displaying output image
  Uint8List data;

  EncodeResponse(this.editableImage, this.displayImage, this.data);
}

/// Encode Request
class EncodeRequest {
  img_lib.Image originalImg;
  String secretMsg;
  String? password;

  EncodeRequest(this.originalImg, this.secretMsg, {this.password});

  bool shouldEncrypt() {
    return (password != null && password != ''); // true if password != null and != '', else, false
  }
}

/// Encode Result Screen Render Request
class EncodeResultScreenRenderRequest{
  Image encodedImage;
  Uint8List encodedByteImage;
  ResultState state;

  EncodeResultScreenRenderRequest(this.state, this.encodedByteImage, this.encodedImage);
}
