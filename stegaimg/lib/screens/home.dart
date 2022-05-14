import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('StegaImg'),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Center(
                      child: Text(
                        'Welcome to StegaImg',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white,
                            fontFamily: 'Cursive'
                        ),
                      )
                  ),
                  Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/encodeimg');
                              },
                              icon: const Icon(Icons.lock_rounded),
                              iconSize: 50,
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/decodeimg');
                              },
                              icon: const Icon(Icons.lock_open_rounded),
                              iconSize: 50,
                              color: Colors.white,
                            )
                          ])
                  )]
            )
        )
    );
  }
}


