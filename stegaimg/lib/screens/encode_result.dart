import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

  @override
  void initState() {
    super.initState();
    savingState = LoadingState.pending;
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

  Future<EncodeResultScreenRenderRequest> requestEncodeImage(EncodeRequest? req)
  async {
    EncodeResponse response = await compute(encodeMessageIntoImage, req);
    return EncodeResultScreenRenderRequest(
        ResultState.success, response.data, response.displayImage, response.imgName);
  }

  Future<void> saveImage(Uint8List imageData, String imgName) async {
    try {
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.status;
        if (!status.isGranted) {
          if (!await Permission.storage.request().isGranted) {
            // experimental; to avoid using buildContext between async gaps
            if (!mounted) { return; }
            // error message
            ScaffoldMessenger.of(context).showSnackBar(
                getSnackBar(
                    Icons.error_outline_rounded, Colors.redAccent,
                    "no storage permission to save image"));
            return;
          }
        }
      }
      setState(() {
        savingState = LoadingState.loading;
      });

      final Directory dir;
      // android
      if (Platform.isAndroid) {
        // create a dir
        dir = await
        Directory("storage/emulated/0/StegaImg").create(recursive: false);
      }
      else {
        // ios
        if (Platform.isIOS) {
          dir = await getApplicationDocumentsDirectory();
        }
        // everything else
        else {
          dir = (await getDownloadsDirectory())!;
        }
      }

      // if directory doesn't exists or didn't get created, then create a dir
      if (!(await dir.exists())) {
        dir.create(recursive: false);
      }

      final String dirPath = dir.path;
      String dt = DateTime.now().toIso8601String(); // 2022-05-28T17:50:31.735
      dt = dt.substring(0, dt.length - 4); // 2022-05-28T17:50:31
      /* File name is changed by image_picker as below:
      image_picker5692167476584564880
      for now I will go with custom name */
      // final String fileName = "${imgName.substring(0, imgName.length-4)}_Encoded";
      // create a new file
      final File encodedImageFinal = await
      File("$dirPath/Image_Encoded_$dt.png").create();
      // File("$dirPath/${fileName}_$dt.png").create();
      // update content to the file
      await encodedImageFinal.writeAsBytes(imageData);

      // experimental; to avoid using buildContext between async gaps
      if (!mounted) { return; }
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(
              Icons.done_rounded, Colors.green, "Saved Successfully"));

      setState(() {
        savingState = LoadingState.success;
      });
    }

    on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          getSnackBar(Icons.error_outline_rounded, Colors.redAccent,
              "Cannot Save $e"));
    }
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
              key: const Key('encoded_screen_back_btn'),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }),
        ),
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: FutureBuilder<EncodeResultScreenRenderRequest>(
              future: renderRequest,
              builder: (BuildContext context,
                  AsyncSnapshot<EncodeResultScreenRenderRequest> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: snapshot.data!.encodedImage,
                                ),
                                const SizedBox(height: 20.0,),
                                IconButton(
                                  onPressed: () {
                                    saveImage(snapshot.data!.encodedByteImage, snapshot.data!.imgName);
                                  },
                                  icon: ButtonLogoWithLoadingAndError(
                                          savingState, Icons.save ),
                                  iconSize: 50,
                                  color: Colors.white,
                                  ),
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
              }),
        ));
  }
}

