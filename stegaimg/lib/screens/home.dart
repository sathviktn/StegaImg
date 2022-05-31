import 'package:flutter/material.dart';
import 'package:stegaimg/utilities/configs.dart';

/// Home
///
/// Welcome Screen of the StegaImg App.
///
/// @category Screens
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('StegaImg'),
          titleTextStyle: const StegaImgTextStyle(fSize: 33, fWeight: FontWeight.w500),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome to StegaImg',
                    style: StegaImgTextStyle(fSize: 35, fWeight: FontWeight.w500),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/encodeImg');
                            },
                          icon: const Icon(Icons.lock_rounded),
                          iconSize: 80,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/decodeImg');
                            },
                          icon: const Icon(Icons.lock_open_rounded),
                          iconSize: 80,
                          color: Colors.white,
                        )
                      ])
                  ]
            )
        )
    );
  }
}


