import 'package:flutter/material.dart'; // new
import 'package:gtk_flutter/src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: <Widget>[
          Image.asset('assets/images/reunion.jpeg'),
          const SizedBox(height: 50),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const SizedBox(height: 25),
          const Header("Welcome to Reunion!"),
          const Paragraph(
            'Explore our upcoming events and join us for a reunion!',
          ),
        ],
      ),
    );
  }
}
