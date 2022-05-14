import 'package:flutter/material.dart';
import 'package:stegaimg/screens/home.dart';
import 'package:stegaimg/screens/encode_img.dart';
import 'package:stegaimg/screens/decode_img.dart';

void main() => runApp(MaterialApp(
  title: 'StegaImg',
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/encodeimg': (context) => EncodeImg(),
    '/decodeimg': (context) => DecodeImg(),
  },
));
