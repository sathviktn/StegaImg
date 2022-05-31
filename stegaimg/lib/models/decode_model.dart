import 'package:image/image.dart' as img_lib;

/// Decode Request
///
/// @category Models: Decode
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
/// @category Models: Decode
class DecodeResponse {
  String decodedMsg;

  DecodeResponse(this.decodedMsg);
}
