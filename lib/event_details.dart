import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'notification.dart';
import 'package:gtk_flutter/models/event.dart';
//import 'package:gtk_flutter/models/user.dart';

DateTime scheduleTime = DateTime.now();

class User {
  final String id;
  final String name;
  final String email;

  User(this.id, this.name, this.email);
}

class EventDetails extends StatelessWidget {
  final Map<String, dynamic> eventData;

  EventDetails(this.eventData);

  @override
  Widget build(BuildContext context) {
    User currentUser = User(
        FirebaseAuth.instance.currentUser!.uid,
        FirebaseAuth.instance.currentUser!.displayName!,
        FirebaseAuth.instance.currentUser!.email!);
    Event event = Event(
      eventData['name'],
      eventData['description'],
      eventData['date'],
      eventData['location'],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(eventData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconAndDetail(Icons.event, '${eventData['name']}'),
            IconAndDetail(Icons.description, '${eventData['description']}'),
            IconAndDetail(Icons.date_range, '${eventData['date']}'),
            IconAndDetail(Icons.location_city, '${eventData['location']}'),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StyledButton(
                      child: Text('RSVP'),
                      onPressed: () {
                        registerForEvent(event, currentUser, context);
                        //print(event);
                      }),
                ),
              ],
            ),
            const Divider(
              height: 8,
              thickness: 1,
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onChanged: (date) => {
                            scheduleTime = date,
                            NotificationService().scheduleNotification(
                                title: event.name,
                                body:
                                    'Event is starting soon! Important details: ${event.date}, ${event.location} ',
                                scheduledNotificationDateTime: scheduleTime),
                          },
                      onConfirm: (date) {
                        print('confirm $date');
                      },
                      currentTime: DateTime(2023, 12, 31, 23, 12, 34));
                },
                label: Text(
                  'Schedule Notification',
                  style: TextStyle(fontSize: 14),
                )),
            Image.asset('assets/confetti.png')
          ],
        ),
      ),
    );
  }

  Future<void> registerForEvent(
      Event event, User currentUser, BuildContext context) async {
    try {
      CollectionReference events =
          FirebaseFirestore.instance.collection('events');

      // Check if the user is already registered for the event
      QuerySnapshot<Object?> existingRegistration =
          await events.where('name', isEqualTo: event.name).limit(1).get();

      if (existingRegistration.docs.isNotEmpty) {
        String eventId = existingRegistration.docs.first.id;

        // Check if the user is already registered for this event
        QuerySnapshot<Map<String, dynamic>> userRegistration = await events
            .doc(eventId)
            .collection('registrations')
            .where('userId', isEqualTo: currentUser.id)
            .get();

        if (userRegistration.docs.isEmpty) {
          await events
              .doc(eventId)
              .collection('registrations')
              .doc(currentUser.id)
              .set({
            'userId': currentUser.id,
            'userName': currentUser.name,
            'userEmail': currentUser.email,
            // Add other user details as needed
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have registered for the event successfully!'),
            ),
          );

          //print('User registered for the event successfully! Event ID: $eventId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You are already registered for this event.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event with the specified name not found.'),
          ),
        );
      }
    } catch (e) {
      print('Error registering for the event: $e');
    }
  }
}
