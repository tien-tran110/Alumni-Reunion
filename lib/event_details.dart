import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'notification.dart';
import 'package:gtk_flutter/models/event.dart';

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
      name: eventData['name'],
      description: eventData['description'],
      date: eventData['date'],
      location: eventData['location'],
    );

    //print(currentUser);

    return Scaffold(
      appBar: AppBar(
        title: Text(eventData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
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
                          modifyEventRegistration(
                              event, currentUser, context, true);
                          //print(event);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StyledButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          modifyEventRegistration(
                              event, currentUser, context, false);
                        }),
                  )
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
                        onConfirm: (date) => {
                              scheduleTime = date,
                              print(scheduleTime),
                              NotificationService().scheduleNotification(
                                  title: event.name,
                                  body:
                                      'Event is starting soon! Important details: ${event.date}, ${event.location} ',
                                  scheduledNotificationDateTime: scheduleTime),
                            },
                        currentTime: DateTime(2023, 12, 31, 23, 12, 34));
                  },
                  label: Text(
                    'Schedule Notification',
                    style: TextStyle(fontSize: 14),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> modifyEventRegistration(Event event, User currentUser,
      BuildContext context, bool register) async {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    try {
      // Check if the event exists and get its ID
      QuerySnapshot<Object?> eventSnapshot =
          await events.where('name', isEqualTo: event.name).limit(1).get();

      if (eventSnapshot.docs.isEmpty) {
        showNotification(context, 'Event with the specified name not found.');
        return;
      }

      String eventId = eventSnapshot.docs.first.id;
      DocumentReference registrationRef =
          events.doc(eventId).collection('registrations').doc(currentUser.id);

      if (register) {
        // Check if the user is already registered
        DocumentSnapshot<Object?> userRegistration =
            await registrationRef.get();

        if (!userRegistration.exists) {
          // Register user for the event
          await registrationRef.set({
            'userId': currentUser.id,
            'userName': currentUser.name,
            'userEmail': currentUser.email,
            // Add other user details as needed
          });
          showNotification(
              context, 'You have registered for the event successfully!');
        } else {
          showNotification(
              context, 'You are already registered for this event.');
        }
      } else {
        // Cancel the event registration
        await registrationRef.delete();
        showNotification(context,
            'You have cancelled your registration for the event successfully!');
      }
    } catch (e) {
      showNotification(context, 'Error modifying event registration: $e');
    }
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
