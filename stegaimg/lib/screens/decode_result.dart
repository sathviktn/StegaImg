import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          title: const Text("Result"),
          titleTextStyle: const StegaTextStyle(fSize: 33, fWeight: FontWeight.w500),
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
              key: const Key('decoded_screen_back_btn'),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ),
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<String>(
            future: decodedMsg,
            builder: (BuildContext context,
                AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20.0,),
                              const Text("Decoded Message: ",
                                  style: StegaTextStyle(fSize: 30)),
                              const Divider(color: Colors.redAccent, indent: 20, endIndent: 20,
                                height: 20, thickness: 5,),
                              const SizedBox(height: 20.0,),
                              GestureDetector(
                                child: Text(snapshot.data!,
                                    style: const StegaTextStyle(fSize: 27),),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: snapshot.data))
                                      .then((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            getSnackBar(Icons.done_rounded, Colors.green,
                                                "Text Copied !"));
                                  });
                                }),
                            ]
                        )
                    )
                );
              }
              else if (snapshot.hasError) {
                return Center(
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_rounded,
                              color: Colors.redAccent, size: 150,),
                            const SizedBox(height: 10.0,),
                            const Text('Oops >_<',
                                style: StegaTextStyle(fSize: 35, fColor: Colors.redAccent)),
                            const SizedBox(height: 10.0,),
                            // To get complete error, print this => ${snapshot.error}
                            const Text('Something went wrong! Please retry with valid inputs.',
                                  style: StegaTextStyle(fSize: 30),),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset('assets/gifs/error.gif'),
                            ),
                          ],
                        )
                    )
                );
              }
              else {
                return Center(
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset('assets/gifs/loading.gif'),
                            ),
                            const Text(
                                'Please wait while StegaImg is decoding your message...',
                                style: StegaTextStyle(fSize: 25, fWeight: FontWeight.w500)
                            )
                          ],
                        )
                    )
                );
              }
            })
    );
  }
}