import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Center(
        child: Container(
          width: 600,
          height: 600,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Ocupa 1 parte
              Expanded(
                flex: 1,
                child: Container(color: Colors.red, height: 100),
              ),
              // Ocupa 2 partes
              Expanded(
                flex: 2,
                child: Container(color: Colors.blue, height: 100),
              ),
              // Ocupa 1 parte
              Expanded(
                flex: 1,
                child: Container(color: Colors.green, height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
