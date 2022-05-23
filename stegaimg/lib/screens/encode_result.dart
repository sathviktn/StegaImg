import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stegaimg/models/encode_model.dart';
import 'package:stegaimg/utilities/configs.dart';
import 'package:stegaimg/services/encode_service.dart';
import 'package:stegaimg/components/loading_button.dart';

class EncodeResult extends StatefulWidget {
  const EncodeResult({Key? key}) : super(key: key);

  @override
  State<EncodeResult> createState() => _ResultState();
}

class _ResultState extends State<EncodeResult> {
  Future<EncodeResultScreenRenderRequest>? renderRequest;
  LoadingState? savingState;

  Future<EncodeResultScreenRenderRequest> requestEncodeImage(EncodeRequest? req)
  async {
    EncodeResponse response = await compute(encodeMessageIntoImage, req);
    return EncodeResultScreenRenderRequest(
        ResultState.success, response.data, response.displayImage);
  }

  Future<void> saveImage(Uint8List imageData) async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        if (!await Permission.storage.request().isGranted) {
          print('no storage permission to save image');
          return;
        }
      }
    }
    setState(() {
      savingState = LoadingState.LOADING;
    });

    dynamic response = await ImageGallerySaver.saveImage(imageData);
    print(response);

    if (response.toString().toLowerCase().contains('not found')) {
      setState(() {
        savingState = LoadingState.ERROR;
      });
      throw FlutterError('save_image_to_gallery_failed');
    }
    setState(() {
      savingState = LoadingState.SUCCESS;
    });
  }


  @override
  void initState() {
    super.initState();
    savingState = LoadingState.PENDING;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      EncodeRequest? encodeReq =
      ModalRoute.of(context)!.settings.arguments as EncodeRequest?;
      renderRequest = requestEncodeImage(encodeReq);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hooray! Encoded Successfully!'),
          leading: IconButton(
              key: const Key('encoded_screen_back_btn'),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: ScreenAdapter(
          child: FutureBuilder<EncodeResultScreenRenderRequest>(
              future: renderRequest,
              builder: (BuildContext context,
                  AsyncSnapshot<EncodeResultScreenRenderRequest> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: ListView(
                      key: const Key('encode_screen'),
                      children: <Widget>[
                        const SizedBox(
                          height: 10.0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: snapshot.data!.encodedImage,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            saveImage(snapshot.data!.encodedByteImage);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ButtonLogoWithLoadingAndError(
                                  savingState, Icons.save),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text('Save'),
                            ],
                          ),
                        )
                      ],
                    ),
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
                          child: Image.asset('assets/error.gif'),
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
                            child: Image.asset('assets/loading.gif'),
                          )),
                      const Text(
                        'Please be patient, stegaimg is encoding your message...',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Colors.white,
                              fontFamily: 'Cursive'
                          )
                      )
                    ],
                  );
                }
              }),
        ));
  }
}

class ScreenAdapter extends StatelessWidget {
  final child;

  ScreenAdapter({this.child});

  @override
  Widget build(BuildContext context) {
    double preferredWidth = 600.0;
    double contentWidth =
    min(MediaQuery.of(context).size.width, preferredWidth);
    return Center(
      child: SizedBox(width: contentWidth, child: child),
    );
  }
}
