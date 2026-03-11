import 'package:flutter/material.dart';

class LisviewBuilderPage extends StatelessWidget {
  LisviewBuilderPage({super.key});
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
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.map),
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ),
    );
  }
}
