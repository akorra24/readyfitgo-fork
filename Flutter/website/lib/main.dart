import 'package:flutter/material.dart';

import 'package:website/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
         fontFamily: 'Inter',
      ),
      home: HomePage(),
    );
  }
}
