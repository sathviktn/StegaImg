import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/models/decode_model.dart';
import 'package:stegaimg/utilities/configs.dart';

import '../components/password_field.dart';

class DecodeImg extends StatefulWidget {
  const DecodeImg({Key? key}) : super(key: key);

  @override
  State<DecodeImg> createState() => _DecodeImgState();
}

class _DecodeImgState extends State<DecodeImg> {

  img_lib.Image? editableImage;
  File? decodingImg;
  TextEditingController? password;
  bool? decrypt;

  @override
  void initState() {
    super.initState();
    password = TextEditingController();
    decrypt = false;
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        editableImage = null;
        return;
      }
      final tempImg = File(image.path);
      setState(() {
        decodingImg = tempImg;
        editableImage = img_lib.decodeImage(decodingImg!.readAsBytesSync());
      });
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
            children: [
              // Image Picker
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Pick an Image',
                          style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: Colors.white,
                            fontSize: 27,
                          ),
                        ),
                        decodingImg == null? IconButton(
                          onPressed: () => getImage(),
                          icon: const Icon(Icons.image_search),
                          iconSize: 50,
                          color: Colors.white,
                        )
                            : Image.file(
                            decodingImg!,
                            width: 300,
                            height: 230,
                            fit: BoxFit.fill
                        )
                      ]
                  )
              ),
              const SizedBox(height: 30),
              // Password
                  Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                      child: CheckboxListTile(
                        title: const Text("Decrypt my message",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'JosefinSans',
                            )),
                        controlAffinity: ListTileControlAffinity.leading,
                        key: const Key('decode_screen_token_checkbox'),
                        value: decrypt,
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        onChanged: (bool? nextVal) {
                          setState(() {
                            decrypt = nextVal;
                          });
                        },
                      )
                  ),
              // Password Field
              PasswordField(
                decrypt,
                password,
                keyVal: 'encode_screen_token_input',
              ),
              const SizedBox(height: 30),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: sendToDecode,
                  iconSize: 50,
                  color: Colors.white,
                ),
              )
            ],),
        )
      )
    );
  }
}
