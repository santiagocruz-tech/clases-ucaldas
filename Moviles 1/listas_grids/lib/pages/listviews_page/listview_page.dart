import 'package:flutter/material.dart';

class LisviewPage extends StatelessWidget {
  const LisviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Route')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: ListView(
            children: const <Widget>[
              ListTile(leading: Icon(Icons.map), title: Text('Map')),
              ListTile(leading: Icon(Icons.photo_album), title: Text('Album')),
              ListTile(leading: Icon(Icons.phone), title: Text('Phone')),
            ],
          ),
        ),
      ),
    );
  }
}
