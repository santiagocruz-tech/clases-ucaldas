import 'package:flutter/material.dart';
import 'package:listas_grids/pages/home_page/home_page.dart';
import 'package:listas_grids/pages/listviews_page/listview_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var items = List<String>.generate(100, (i) => 'Item $i');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: HomePage(items: items),
    );
  }
}
