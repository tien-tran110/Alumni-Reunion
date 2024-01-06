// class Event {
//   final String name;
//   final String description;
//   final String date;
//   final String location;

//   Event(
//     this.name,
//     this.description,
//     this.date,
//     this.location,
//   );
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String name;
  final String description;
  final String date;
  final String location;

  Event(
      {required this.name,
      required this.description,
      required this.date,
      required this.location});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    ;
    return Event(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'location': location,
    };
  }
}
