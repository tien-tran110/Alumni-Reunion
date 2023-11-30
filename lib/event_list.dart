import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:gtk_flutter/event_details.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var events = snapshot.data?.docs;

          return ListView.builder(
            itemCount: events?.length,
            itemBuilder: (context, index) {
              var event = events?[index].data();

              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.album),
                      title: Text(event?['name']),
                      subtitle: Text(event?['description']),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton.icon(
                          icon: Icon(Icons.arrow_circle_right),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetails(event!),
                              ),
                            );
                          },
                          label: Text('Details'),
                        ),
                        const SizedBox(width: 8),
                        // ElevatedButton.icon(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.favorite),
                        //   label: Text('Like'),
                        // ),
                        // const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
