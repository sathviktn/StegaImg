import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:stegaimg/models/encode_model.dart';
import 'package:stegaimg/services/encode_service.dart';
import 'package:stegaimg/utilities/configs.dart';

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
        return;
      }
        final tempImg = File(image.path);
        setState(() {
          encodingImg = tempImg;
          editableImage = img_lib.decodeImage(encodingImg!.readAsBytesSync());
          pickedImg = true;
        });
      }

    on PlatformException catch(e){
      print('Failed to pick image: $e');
      return;
    }
  }

  Future<void> sendToEncode() async {
    EncodeRequest req = EncodeRequest(editableImage!, secretMsg!.text,
        password: password!.text);
    Navigator.pushNamed(context, '/encodeResult', arguments: req);
  }

  Future<void> onMessageChange(String msg) async {
    if (!pickedImg ||
        editableImage == null ||
        imageByteSize == 0) {
      setState(() {
        capacityUsage = 'Not applicable, no image uploaded';
        capacityUsageStats = 1.0;
      });
    } else {
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
        title: const Text('StegaImg'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Image Picker
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Pick an Image',
                              style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Colors.white,
                              fontFamily: 'Cursive'
                              ),
                            ),
                            encodingImg == null? IconButton(
                              onPressed: () => getImage(),
                              icon: const Icon(Icons.image_search),
                              iconSize: 50,
                              color: Colors.white,
                            )
                                : Image.file(
                                encodingImg!,
                                width: 300,
                                height: 230,
                                fit: BoxFit.fill
                            )
                          ]
                        )
                    ),
                    const SizedBox(height: 30),
                    // Secret Message
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              controller: secretMsg,
                              onChanged: onMessageChange,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter the Secret Message',
                                hintStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    color: Colors.white,
                                    fontFamily: 'Cursive'
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 30,
                                  letterSpacing: 2.0,
                                  color: Colors.white
                              ),
                            )
                          ]
                        )
                    ),
                    const SizedBox(height: 30),
                  // Password
                    Row(
                      children: <Widget>[
                        Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                            child: Checkbox(
                              key: const Key('encode_screen_token_checkbox'),
                              value: encrypt,
                              activeColor: Colors.white,
                              onChanged: (bool? nextVal) {
                                setState(() {
                                  encrypt = nextVal;
                                });
                              },
                            )
                        ),
                        const Text('Encrypt my message',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white,
                            fontFamily: 'Cursive'
                        ),
                        ),
                      ],
                    ),
                    TokenInputField(
                      encrypt,
                      password,
                      keyVal: 'encode_screen_token_input',
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        label: const Text('Next'),
                        icon: const Icon(Icons.navigate_next),
                        onPressed: sendToEncode,
                      ),
                    )
                  ]
              )
          )
      )
    );
  }
}

class TokenInputField extends StatefulWidget {
  final TextEditingController? ctrl;
  final bool? enable;
  final String? keyVal;

  const TokenInputField(this.enable, this.ctrl, {this.keyVal});

  @override
  State<StatefulWidget> createState() {
    return _TokenInputField();
  }
}

class _TokenInputField extends State<TokenInputField> {
  bool? visible;

  @override
  void initState() {
    super.initState();
    visible = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enable!) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Theme(data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                  child: Checkbox(
                  value: visible,
                  activeColor: Colors.white,
                  onChanged: (bool? nextVal) {
                    setState(() {
                      visible = nextVal;
                    });
                  })
              ),
              const Text('Show token',
              style: TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
                fontFamily: 'Cursive'
                )
              ),
            ],
          ),
          TextField(
            key: Key(widget.keyVal!),
            controller: widget.ctrl,
            obscureText: !visible!,
            decoration: const InputDecoration(
              hintText: 'Enter a Strong Password',
              hintStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontFamily: 'Cursive',
                color: Colors.white
              )
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              letterSpacing: 2.0,
              color: Colors.white
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

