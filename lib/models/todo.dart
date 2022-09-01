import 'package:firebase_database/firebase_database.dart';

class Todo {
  String? key;
  String subject, userId;
  bool completed;

  Todo(this.subject, this.completed, this.userId, [this.key]);

  Todo.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        subject = (snapshot.value as Map)['subject'],
        completed = (snapshot.value as Map)['completed'],
        userId = (snapshot.value as Map)['userId'];

  Map<String, dynamic> toJson() =>
      {'subject': subject, 'completed': completed, 'userId': userId};
}
