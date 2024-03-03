import 'package:easy_chat/data/message_dao.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  final messageDao = MessageDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // textfield and add button
          Row(children: [
            TextField(
              
            ),
            IconButton(onPressed: () {
              
            }, icon: Icon(Icons.add))
          ],)
        ],
      ),
    );
  }
}