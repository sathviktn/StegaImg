import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/components/loading_button.dart';
import 'package:stegaimg/models/encode_model.dart';
import 'package:stegaimg/utilities/configs.dart';
import 'package:stegaimg/components/password_field.dart';
import 'package:stegaimg/components/encoder_components.dart';

/// Encode Img
///
/// Screen for Encode operation.
///
/// @category Screens
class EncodeImg extends StatefulWidget {
  const EncodeImg({Key? key}) : super(key: key);

  @override
  State<EncodeImg> createState() => _EncodeImgState();
}

class _EncodeImgState extends State<EncodeImg> {

  File? encodingImg;
  img_lib.Image? editableImage;
  String? imgName;
  bool? encrypt;
  late LoadingState getState;
  TextEditingController? secretMsg;
  TextEditingController? password;
  late bool pickedImg;
  double? capacityUsageStats;
  late String capacityUsage;
  int? imageByteSize;

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      getState = LoadingState.loading;

      if (image == null) {
        editableImage = null;
        pickedImg = false;
        getState = LoadingState.pending;
      }
      else {
        final tempImg = File(image.path);
        ImageConversionResponse res = await compute<ImageConversionRequest, ImageConversionResponse>
          (convertImageToData, ImageConversionRequest(tempImg));

        setState(() {
          encodingImg = tempImg;
          editableImage = res.editableImage; // img_lib.decodeImage(encodingImg!.readAsBytesSync());
          imageByteSize = res.imageByteSize;
          imgName = path.basename(image.path);
          pickedImg = true;
          getState = LoadingState.success;
          capacityUsageStats = 0.0;
          capacityUsage = 'Usage: $capacityUsageStats%';
        });
      }
    }

    on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(Icons.error_outline_rounded, Colors.redAccent,
              "Failed to pick image: $e"));
      return;
    }
  }

  Future<void> sendToEncode() async {
      final secret = secretMsg?.text;
      if (editableImage != null && secret != "") {
        EncodeRequest req = EncodeRequest(imgName!, editableImage!, secret!,
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
        capacityUsage = 'No image uploaded';
        capacityUsageStats = 0.0;
      });
    }
    else {
      double usage = await compute(calculateCapacityUsage,
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
    imgName = "Image";
    secretMsg = TextEditingController();
    password = TextEditingController();
    encrypt = false;
    pickedImg = false;
    getState = LoadingState.pending;
    capacityUsage = 'No image uploaded';
    capacityUsageStats = 0.0;
    imageByteSize = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encode'),
        titleTextStyle: const StegaImgTextStyle(fSize: 33, fWeight: FontWeight.w500),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
            key: const Key('encoded_result_screen_back_btn'),
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 15,),
                    // Image Picker - Start
                    const Text('Pick an Image', style: StegaImgTextStyle(fSize: 30, fColor: Colors.lightBlueAccent),),
                    IconButton(
                      icon: StegaCustomIcon(getState, Icons.image_search),
                      iconSize: 50,
                      color: Colors.white,
                      onPressed: () => getImage(),),
                    !pickedImg ? Image.asset("assets/gifs/noImg.gif",
                      width: 300, height: 180, fit: BoxFit.fitWidth,) :
                    Image.file(encodingImg!, width: 300, height: 230, fit: BoxFit.fill),
                    // Image Picker - End
                    const SizedBox(height: 15,),
                    // Usage Stats - Start
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(capacityUsage,
                            style: const StegaImgTextStyle(fSize: 18)),
                          CircularProgressIndicator(
                            value: capacityUsageStats,
                            color: Colors.red,
                            backgroundColor: Colors.grey,
                          )
                        ]),
                    // Usage Stats - End
                    const SizedBox(height: 15,),
                    // Secret Message - Start
                    TextField(
                      key: const Key('encode_screen_msg_input'),
                      controller: secretMsg,
                      onChanged: onMessageChange,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter the secret',
                        hintStyle: StegaImgTextStyle(fSize: 30, fColor: Colors.lightBlueAccent),
                      ),
                      textAlign: TextAlign.center,
                      style: const StegaImgTextStyle(fSize: 30),
                      minLines: 1,
                      maxLines: 3,
                    ),
                    // Secret Message - End
                    const SizedBox(height: 15),
                    // Password - Start
                    Theme(
                        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                          child: CheckboxListTile(
                            title: const Text("Encrypt my message",
                                style: StegaImgTextStyle(
                                fSize: 25,
                                fStyle:FontStyle.italic,
                                fColor: Colors.greenAccent
                                )),
                            key: const Key('encode_screen_token_checkbox'),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: encrypt,
                            activeColor: Colors.greenAccent,
                            checkColor: Colors.black,
                            onChanged: (bool? nextVal) {
                              setState(() {
                                encrypt = nextVal;
                              });
                              },
                          )
                    ),
                    StegaImgPasswordField(
                      encrypt,
                      password,
                      keyVal: 'encode_screen_token_input',
                    ),
                    // Password - End
                    const SizedBox(height: 15),
                    // Encode Button - Start
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                      ),
                        child: IconButton(
                          icon: const Icon(Icons.navigate_next),
                          onPressed: sendToEncode,
                          iconSize: 50,
                          color: Colors.black,
                        )
                    ),
                    // Encode Button - End
                  ]
              )
              )
    );
  }
}

