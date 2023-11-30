import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:gtk_flutter/event_list.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'src/authentication.dart'; // new

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reunion'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/reunion.jpeg'),
          const SizedBox(height: 16),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("Welcome to Reunion!"),
          const Paragraph(
            'Explore our upcoming events and join us for a reunion!',
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8, top: 16),
              child: StyledButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EventList()));
                  },
                  child: Text('Explore Events')),
            ),
          ]),
        ],
      ),
    );
  }
}
