import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/models/encode_model.dart';
import 'package:stegaimg/utilities/configs.dart';
import 'package:stegaimg/components/password_field.dart';
import 'package:stegaimg/components/encoder_components.dart';

class EncodeImg extends StatefulWidget {
  const EncodeImg({Key? key}) : super(key: key);

  @override
  State<EncodeImg> createState() => _EncodeImgState();
}

class _EncodeImgState extends State<EncodeImg> {

  File? encodingImg;
  img_lib.Image? editableImage;
  bool? encrypt;
  TextEditingController? secretMsg;
  TextEditingController? password;
  late bool pickedImg;
  double? capacityUsageStats;
  late String capacityUsage;
  int? imageByteSize;

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        editableImage = null;
        pickedImg = false;
      }
      else {
        final tempImg = File(image.path);
        UploadedImageConversionResponse res = await compute<UploadedImageConversionRequest, UploadedImageConversionResponse>
          (convertUploadedImageToData, UploadedImageConversionRequest(tempImg));

        setState(() {
          encodingImg = tempImg;
          editableImage = res.editableImage; // img_lib.decodeImage(encodingImg!.readAsBytesSync());
          imageByteSize = res.imageByteSize;
          pickedImg = true;
          capacityUsageStats = 0.0;
          capacityUsage = 'Usage: $capacityUsageStats%';
        });
      }
    }

    on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(Icons.error_outline_rounded, Colors.redAccent, "Failed to pick image: $e"));
      return;
    }
  }

  Future<void> sendToEncode() async {
      final secret = secretMsg?.text;
      if (editableImage != null && secret != "") {
        EncodeRequest req = EncodeRequest(editableImage!, secret!,
            password: password!.text);
        Navigator.pushNamed(context, '/encodeResult', arguments: req);
      }
      else{
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(Icons.error_outline_rounded, Colors.redAccent, "null inputs !"));
    }
  }

  Future<void> onMessageChange(String msg) async {
    if (!pickedImg || editableImage == null || imageByteSize == 0 || encodingImg == null) {
      setState(() {
        capacityUsage = 'Not applicable, no image uploaded';
        capacityUsageStats = 0.0;
      });
    }
    else {
      double usage = await calculateCapacityUsageAsync(
          CapacityUsageRequest(msg, imageByteSize));
      usage = min(usage, 0.99);
      String strUsage = (usage * 100.0).toString();
      if (strUsage.length > 5) {
        strUsage = strUsage.substring(1, 6);
      }
      setState(() {
        capacityUsageStats = usage;
        capacityUsage = 'Usage: $strUsage%';
      });
    }
  }


  @override
  void initState() {
    super.initState();
    secretMsg = TextEditingController();
    password = TextEditingController();
    encrypt = false;
    pickedImg = false;
    capacityUsage = 'Not applicable, no image uploaded';
    capacityUsageStats = 0.0;
    imageByteSize = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encode'),
        titleTextStyle: const TextStyle(
            fontSize: 33,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'JosefinSans'
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Image Picker - Start
                    const Text('Pick an Image', style: StegaTextStyle(fSize: 27),),
                    const SizedBox(height: 20,),
                    !pickedImg? IconButton(     //encodingImg == null
                      onPressed: () => getImage(),
                      icon: const Icon(Icons.image_search),
                      iconSize: 50,
                      color: Colors.white,
                    ) : Image.file(
                        encodingImg!,
                        width: 300,
                        height: 230,
                        fit: BoxFit.fill
                    ),
                    // Image Picker - End
                    const SizedBox(height: 20,),
                    // Usage Stats - Start
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(capacityUsage,
                            style: const StegaTextStyle(fSize: 20)),
                          CircularProgressIndicator(
                            value: capacityUsageStats,
                            color: Colors.red,
                            backgroundColor: Colors.grey,
                          )
                        ]),
                    // Usage Stats - End
                    const SizedBox(height: 20,),
                    // Secret Message - Start
                    TextField(
                      key: const Key('encode_screen_msg_input'),
                      controller: secretMsg,
                      onChanged: onMessageChange,
                      obscureText: false,
                      decoration: StegaInputDec(
                          hint: 'Enter the Secret Message',
                          hFontSize: 27
                      ),
                      textAlign: TextAlign.center,
                      style: const StegaTextStyle(fSize: 27),
                      minLines: 1,
                      maxLines: 3,
                    ),
                    // Secret Message - End
                    const SizedBox(height: 20),
                    // Password - Start
                    Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white
                        ),
                        child: CheckboxListTile(
                          title: const Text("Encrypt my message",
                              style: StegaTextStyle(
                                  fSize: 23,
                                  fStyle:FontStyle.italic
                              )
                          ),
                          key: const Key('encode_screen_token_checkbox'),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: encrypt,
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                          onChanged: (bool? nextVal) {
                            setState(() {
                              encrypt = nextVal;
                            });
                          },
                        )
                    ),
                    PasswordField(
                      encrypt,
                      password,
                      keyVal: 'encode_screen_token_input',
                    ),
                    // Password - End
                    const SizedBox(height: 20),
                    // Encode Button - Start
                    IconButton(
                      icon: const Icon(Icons.navigate_next),
                      onPressed: sendToEncode,
                      iconSize: 50,
                      color: Colors.white,
                    ),
                    // Encode Button - End
                  ]
              )
          )
      )
    );
  }
}

