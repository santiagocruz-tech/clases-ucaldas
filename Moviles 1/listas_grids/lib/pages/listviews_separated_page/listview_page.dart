import 'package:flutter/material.dart';

class LisviewSeparatedPage extends StatelessWidget {
  LisviewSeparatedPage({super.key});
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
          child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.map),
                title: Text('Item $index'),
              );
            },
            separatorBuilder: (context, index) => Divider(color: Colors.amber),
            itemCount: items.length,
          ),
        ),
      ),
    );
  }
}
