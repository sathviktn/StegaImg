import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EncodeImg extends StatefulWidget {
  const EncodeImg({Key? key}) : super(key: key);

  @override
  State<EncodeImg> createState() => _EncodeImgState();
}

class _EncodeImgState extends State<EncodeImg> {

  File? encodingimg;

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final tempImg = File(image.path);
      setState(() => encodingimg = tempImg);
    }
    on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
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
                            encodingimg == null? IconButton(
                              onPressed: () => getImage(),
                              icon: const Icon(Icons.image_search),
                              iconSize: 50,
                              color: Colors.white,
                            ): Image.file(
                                encodingimg!,
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
                          children: const <Widget>[
                            TextField(
                              decoration: InputDecoration(
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
                              style: TextStyle(
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
                    Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter a Strong Message',
                                  hintStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontFamily: 'Cursive',
                                    color: Colors.white
                                  )
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    letterSpacing: 2.0,
                                    color: Colors.white
                                ),
                              )
                            ]
                        )
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        label: const Text('Next'),
                        icon: const Icon(Icons.navigate_next),
                        onPressed: (){},
                      ),
                    )
                  ]
              )
          )
      )
    );
  }
}
