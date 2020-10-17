import 'package:flutter/material.dart';
import './screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking Recipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "PTSans",
        primarySwatch: Colors.red,
        hintColor: Colors.black87,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
