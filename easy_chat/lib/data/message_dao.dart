import 'package:easy_chat/data/message.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageDao {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');

  void saveMessage(Message message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messagesRef;
  }
}
