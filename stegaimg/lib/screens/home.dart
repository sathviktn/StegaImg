import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleTextStyle: const TextStyle(
              fontSize: 33,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: 'JosefinSans'
          ),
          backgroundColor: Colors.blueGrey,
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
                            fontSize: 33,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'JosefinSans'
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
                                Navigator.pushNamed(context, '/encodeImg');
                              },
                              icon: const Icon(Icons.lock_rounded),
                              iconSize: 50,
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/decodeImg');
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


