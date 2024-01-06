import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/event_details.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                            //print(event);

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
