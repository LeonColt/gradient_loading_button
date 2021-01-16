import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Progress Button Sample",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sample"),
        ),
        body: Center(
          child: Container(
            width: 200,
            height: 60,
            child: LoadingButton(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: new LinearGradient(
                  colors: <Color>[
                    Colors.red,
                    Colors.blue,
                  ]
              ),
              strokeWidth: 2,
              child: Text(
                "Sample",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              errorChild: const Icon(
                Icons.close_sharp,
                color: Colors.white,
              ),
              successChild: const Icon(
                Icons.check_sharp,
                color: Colors.white,
              ),
              onPressed: ( controller ) async {
                await controller.loading();
                await new Future.delayed( const Duration( seconds: 3 ) );
                if ( Random.secure().nextBool() )
                  await controller.success();
                else await controller.error();
              },
            ),
          ),
        ),
      ),
    );
  }
}
