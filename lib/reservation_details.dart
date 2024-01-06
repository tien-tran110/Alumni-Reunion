import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/event_details.dart';
import 'package:gtk_flutter/models/event.dart';

class User {
  final String id;
  final String name;
  final String email;

  User(this.id, this.name, this.email);
}

class ReservationDetails extends StatefulWidget {
  const ReservationDetails({super.key});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  Stream<List<Event>> getUserEvents() {
    User? currentUser = User(
        FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.displayName!,
        FirebaseAuth.instance.currentUser!.email!);
    // Create a StreamController
    final controller = StreamController<List<Event>>();

    // Reference to Firestore collection
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('events');

    // Listen to the snapshot stream
    eventsCollection.snapshots().listen((snapshot) async {
      List<Event> userEvents = [];

      for (var doc in snapshot.docs) {
        // Assuming 'registrations' is a subcollection of each event
        var registrations = doc.reference.collection('registrations');

        // Await the future from the query
        var registrationSnapshot = await registrations
            .where('userId', isEqualTo: currentUser.id)
            .get();

        if (registrationSnapshot.docs.isNotEmpty) {
          userEvents.add(Event.fromFirestore(doc));
        }
      }

      // Add the list of events to the stream
      controller.add(userEvents);
    }, onError: (error) {
      // Handle errors and add an error event to the stream
      controller.addError(error);
    });

    return controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: getUserEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('You have not registered for any events.',
                    style: const TextStyle(fontSize: 18)),
              ),
            ],
          );
        }
        List<Event>? events = snapshot.data;

        return ListView.builder(
          itemCount: events!.length,
          itemBuilder: (context, index) {
            Event event = events[index];
            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(event.name),
                    subtitle: Text(event.description),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(event.toMap()),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
