import 'dart:math';

import 'package:easy_chat/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class AddUsersPage extends StatefulWidget {
  const AddUsersPage({super.key});

  @override
  State<AddUsersPage> createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Colors.white30, width: 1.5)),
              title: Row(
                children: [
                  const Text("Name: "),
                  Expanded(child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: nameController,
                  ))
                ],
              ),
            ),
            const SizedBox(height: 20,),

            // year
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Colors.white30, width: 1.5)),
              title: Row(
                children: [
                  const Text("Email: "),
                  Expanded(child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: emailController,
                  ))
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // poster
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: Colors.white30, width: 1.5)),
              title: Row(
                children: [
                  const Text("Age: "),
                  Expanded(child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: ageController,
                  ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            
        const SizedBox(height: 20),
        ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)), onPressed: () {
          

          DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('users');

  databaseReference.push().set({
    'name': nameController.text,
    'email': emailController.text,
    'age': ageController.text,
  });
          Navigator.pop(context);
        }, child: const Text("Add"))
          ],
        ),
      ),
    );
  }
}