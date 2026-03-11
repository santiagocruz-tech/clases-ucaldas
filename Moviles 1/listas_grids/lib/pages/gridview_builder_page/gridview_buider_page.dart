import 'package:flutter/material.dart';

class GridViewBuilderPage extends StatelessWidget {
  GridViewBuilderPage({super.key});
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
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return index == 83
                  ? Card(
                      child: Center(
                        child: Column(
                          children: [
                            Text('Item $index'),
                            ElevatedButton(
                              onPressed: () {
                                const snackBar = SnackBar(
                                  content: Text('Yay! A SnackBar!'),
                                );

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                              },
                              child: Text('Press me'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(child: Center(child: Text('$index')));
            },
          ),
        ),
      ),
    );
  }
}
