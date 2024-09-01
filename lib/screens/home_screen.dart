import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UK Climate Data'),
      ),
      // Two Options as List Tile on for chart screen and one for google map
      body:
      ListView(
        children: [
          ListTile(
            title: const Text('Chart Screen'),
            onTap: () {
              Navigator.pushNamed(context, '/chart_screen').whenComplete((){
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              });
            },
          ),
          ListTile(
            title: const Text('Table View'),
            onTap: () {
              Navigator.pushNamed(context, '/table_view');
            },
          ),
          ListTile(
            title: const Text('Google Map'),
            onTap: () {
              Navigator.pushNamed(context, '/google_map');
            },
          ),
        ],)
    );
  }
}
