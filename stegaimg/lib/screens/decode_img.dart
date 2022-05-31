import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/models/decode_model.dart';
import 'package:stegaimg/utilities/configs.dart';
import '../components/loading_button.dart';
import '../components/password_field.dart';

/// Decode Img
///
/// Screen for Decode operation.
///
/// @category Screens
class DecodeImg extends StatefulWidget {
  const DecodeImg({Key? key}) : super(key: key);

  @override
  State<DecodeImg> createState() => _DecodeImgState();
}

class _DecodeImgState extends State<DecodeImg> {

  img_lib.Image? editableImage;
  File? decodingImg;
  late LoadingState getState;
  TextEditingController? password;
  bool? decrypt;

  @override
  void initState() {
    super.initState();
    password = TextEditingController();
    decrypt = false;
    getState = LoadingState.pending;
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      getState = LoadingState.loading;

      if (image == null) {
        setState((){
          editableImage = null;
          getState = LoadingState.pending;
        });
      }
      else {
        final tempImg = File(image.path);
        setState(() {
          decodingImg = tempImg;
          editableImage = img_lib.decodeImage(decodingImg!.readAsBytesSync());
          getState = LoadingState.success;
        });
      }
    }

    on PlatformException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(Icons.error_outline_rounded, Colors.redAccent, "Failed to pick image: $e"));
      return;
    }
  }

  void sendToDecode() {
    if(editableImage != null){
      DecodeRequest req = DecodeRequest(editableImage, password: password!.text);
      Navigator.pushNamed(context, '/decodeResult', arguments: req);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(Icons.error_outline_rounded, Colors.redAccent, "null inputs !"));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decode'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25,),
              // Image Picker - Start
              const Text('Pick an Image', style: StegaImgTextStyle(fSize: 30),),
              IconButton(
                icon: StegaCustomIcon(getState, Icons.image_search),
                iconSize: 50,
                color: Colors.white,
                onPressed: () => getImage(),),
              decodingImg == null ? Image.asset("assets/gifs/noImg.gif",
                width: 300, height: 180, fit: BoxFit.fitWidth,) :
              Image.file(decodingImg!, width: 300, height: 230, fit: BoxFit.fill),
              // Image Picker - End
              const SizedBox(height: 25),
              // Password - Start
              Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                  child: CheckboxListTile(
                    title: const Text("Decrypt my message",
                        style: StegaImgTextStyle(fSize: 25, fStyle: FontStyle.italic)),
                    controlAffinity: ListTileControlAffinity.leading,
                    key: const Key('decode_screen_token_checkbox'),
                    value: decrypt,
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    onChanged: (bool? nextVal) {
                      setState(() {
                        decrypt = nextVal;
                      });},
                  )
              ),
              StegaImgPasswordField(
                decrypt,
                password,
                keyVal: 'encode_screen_token_input',
              ),
              // Password - End
              const SizedBox(height: 25),
              // Decode Button - Start
              Center(
                child: IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: sendToDecode,
                  iconSize: 50,
                  color: Colors.white,
                ),
                // Decode Button - End
              )
            ],),
        )
      )
    );
  }
}
