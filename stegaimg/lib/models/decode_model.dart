import 'package:image/image.dart' as img_lib;

/// Decode Request
///
/// {@category Models}
class DecodeRequest {
  img_lib.Image? original;
  String? password;

  DecodeRequest(this.original, {this.password});

  bool shouldDecrypt() {
    return (password != null && password != '');
  }
}

/// Decode Response
///
/// {@category Models}
class DecodeResponse {
  String decodedMsg;

  DecodeResponse(this.decodedMsg);
}
