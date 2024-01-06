import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/event_list.dart';
import 'package:gtk_flutter/home_page.dart';
import 'package:gtk_flutter/profile.dart';
import 'package:gtk_flutter/reservation_details.dart';
import 'package:gtk_flutter/yearbook.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    void navigateBottomBar(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    final List<Widget> pages = [
      HomePage(),
      YearbookPage(),
      EventList(),
      ReservationDetails(),
      UserProfile(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reunion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOutUser();
            },
          )
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_album), label: 'Yearbook'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
