import 'package:flutter/material.dart';

class GridPage extends StatelessWidget {
  GridPage({super.key});
  var items = List<String>.generate(100, (i) => 'Item $i');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: GridView.count(
            crossAxisCount: 2, // 2 columnas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: EdgeInsets.all(10),
            children: List.generate(20, (index) {
              return Card(child: Center(child: Text('Item $index')));
            }),
          ),
        ),
      ),
    );
  }
}
