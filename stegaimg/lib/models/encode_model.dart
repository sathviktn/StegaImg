import 'dart:io';
import 'package:image/image.dart' as img_lib;
import 'package:flutter/widgets.dart';
import 'dart:typed_data';
import 'package:stegaimg/utilities/configs.dart';

/// Encode Response
///
/// {@category Models}
class EncodeResponse {
  img_lib.Image editableImage;   // not needed
  Image displayImage;  // for displaying output image
  Uint8List data;
  String imgName;

  EncodeResponse(this.editableImage, this.displayImage, this.data, this.imgName);
}

/// Encode Request
///
/// {@category Models}
class EncodeRequest {
  String imgName;
  img_lib.Image originalImg;
  String secretMsg;
  String? password;

  EncodeRequest(this.imgName, this.originalImg, this.secretMsg, {this.password});

  bool shouldEncrypt() {
    return (password != null && password != ''); // true if password != null and != '', else, false
  }
}

/// Encode Result Screen Render Request
///
/// {@category Models}
class EncodeResultScreenRenderRequest{
  Image encodedImage;
  Uint8List encodedByteImage;
  ResultState state;
  String imgName;

  EncodeResultScreenRenderRequest(this.state, this.encodedByteImage, this.encodedImage, this.imgName);
}

/// Uploaded Image Conversion Request
///
/// {@category Services: Requests}
class UploadedImageConversionRequest {
  File? file;

  UploadedImageConversionRequest(this.file);
}

/// Upload Image Conversion Response
///
/// {@category Models}
class UploadedImageConversionResponse {
  img_lib.Image editableImage;
  Image displayableImage;
  int imageByteSize;

  UploadedImageConversionResponse(
      this.editableImage, this.displayableImage, this.imageByteSize);
}
