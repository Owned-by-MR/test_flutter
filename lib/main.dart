import 'package:flutter/material.dart';
import 'search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        // accentColor: Colors.greenAccent,
      ),
      home: DefaultTabController(
        length: 2,
        child: SearchScreen(),
      ),
    );
  }
}
