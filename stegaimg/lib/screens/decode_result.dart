import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stegaimg/models/decode_model.dart';
import 'package:stegaimg/services/decode_service.dart';
import 'package:stegaimg/utilities/configs.dart';

class DecodeResult extends StatefulWidget {
  const DecodeResult({Key? key}) : super(key: key);

  @override
  State<DecodeResult> createState() => _DecodeResultState();
}

class _DecodeResultState extends State<DecodeResult> {
  Future<String>? decodedMsg;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      DecodeRequest? req = ModalRoute.of(context)!.settings.arguments as DecodeRequest?;
      decodedMsg = decodeMsg(req);
    }
  }

  Future<String> decodeMsg(DecodeRequest? req) async {
    DecodeResponse response = await compute(decodeMessageFromImage, req);
    String msg = response.decodedMsg;
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Decoded Successfully !"),
          leading: IconButton(
              key: const Key('decoded_screen_back_btn'),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<String>(
              future: decodedMsg,
              builder: (BuildContext context,
                  AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                      child: ListView(
                          children: <Widget>[
                            const SizedBox(
                              height: 30.0,
                            ),
                            const Text("Decoded Message: ",
                                style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Colors.white,
                              fontSize: 25,
                            )
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Center(
                              child: Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  fontFamily: 'JosefinSans',
                                  color: Colors.white,
                                  fontSize: 27,
                                ),
                              ),
                            ),
                          ]
                      )
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Center(
                            child: Text('Whoops >_<',
                              style: TextStyle(fontSize: 30.0),
                            )),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Center(
                            child: Text('It seems something went wrong: ${snapshot.error}')),
                        const SizedBox(
                          height: 5.0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset('assets/gifs/error.gif'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset('assets/gifs/loading.gif'),
                          )),
                      const Text(
                          'Please be patient, stegaimg is decoding your message...',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'JosefinSans'
                          )
                      )
                    ],
                  );
                }
              }),
    );
  }
}