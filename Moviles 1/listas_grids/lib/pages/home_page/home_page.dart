import 'package:flutter/material.dart';
import 'package:listas_grids/pages/grid_page/grid_page.dart';
import 'package:listas_grids/pages/gridview_builder_page/gridview_buider_page.dart';
import 'package:listas_grids/pages/listviews_builder_page/listview_page.dart';
import 'package:listas_grids/pages/listviews_page/listview_page.dart';
import 'package:listas_grids/pages/listviews_separated_page/listview_page.dart';
import 'package:listas_grids/pages/single_child_scrollview_page/single_child_scroll_view_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menú de Navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Ejemplo de listview'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const LisviewPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Ejemplo de listview.builder'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => LisviewBuilderPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Ejemplo de listview.separated'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => LisviewSeparatedPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ejemplo de gridview'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => GridPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ejemplo de GridView.builder'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => GridViewBuilderPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Ejemplo de SingleChildScrollView'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => SingleChildScrollViewPage(),
                  ),
                );
              },
            ),
            UserAccountsDrawerHeader(
              accountName: Text('Ricardo'),
              accountEmail: Text('ricardo@example.com'),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Listas y Grids')),
      body: Center(
        child: Text(
          'Esta aplicación contiene ejemplos de ListView y Grids en el menú de navegación.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
