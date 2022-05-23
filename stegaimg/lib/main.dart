import 'package:flutter/material.dart';
import 'package:stegaimg/screens/home.dart';
import 'package:stegaimg/screens/encode_img.dart';
import 'package:stegaimg/screens/decode_img.dart';
import 'package:stegaimg/screens/encode_result.dart';

void main() => runApp(MaterialApp(
  title: 'StegaImg',
  initialRoute: '/',
  routes: {
    '/': (context) => const Home(),
    '/encodeImg': (context) => const EncodeImg(),
    '/decodeImg': (context) => const DecodeImg(),
    '/encodeResult': (context) => const EncodeResult(),
  },
));
