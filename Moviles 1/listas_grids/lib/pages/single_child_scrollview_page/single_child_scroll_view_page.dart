import 'package:flutter/material.dart';

class SingleChildScrollViewPage extends StatelessWidget {
  SingleChildScrollViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 200, color: Colors.red),
            Container(height: 200, color: Colors.blue),
            Container(height: 200, color: Colors.green),
            Container(height: 200, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}
