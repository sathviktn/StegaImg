import 'package:flutter/material.dart';

class DecodeImg extends StatefulWidget {
  const DecodeImg({Key? key}) : super(key: key);

  @override
  State<DecodeImg> createState() => _DecodeImgState();
}

class _DecodeImgState extends State<DecodeImg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StegaImg'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Text('Decode'),
    );
  }
}
