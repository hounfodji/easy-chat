import 'package:easy_chat/firebase_options.dart';
import 'package:easy_chat/pages/add_note_page.dart';
import 'package:easy_chat/pages/add_users_page.dart';
import 'package:easy_chat/pages/message_llist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "todo app",
      theme: ThemeData(
        primaryColor: Colors.greenAccent[700],
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  TextEditingController second = TextEditingController();

  TextEditingController third = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  var l;
  var g;
  var k;
  var databaseReferenceUsersList;
  var userKey;
  @override
  Widget build(BuildContext context) {
    // get todos
    final ref = fb.ref().child('todos');

    // get users
    DatabaseReference databaseReferenceUsers =
        FirebaseDatabase.instance.ref().child('users');
    print(databaseReferenceUsers);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo[900],
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AddNotePage(),
              ),
            );
          },
          child: Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Todos',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          backgroundColor: Colors.indigo[900],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AddUsersPage();
                    },
                    fullscreenDialog: true));
              },
              icon: const Icon(Icons.add)),
        ),
        body: Column(
          children: [
            // users

            FirebaseAnimatedList(
        query: databaseReferenceUsers,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          
          
          var databaseReferenceUsersValue =
              snapshot.value.toString(); // {subtitle: webfun, title: subscribe}
              print(databaseReferenceUsersValue);

          g = databaseReferenceUsersValue.replaceAll(
              RegExp("{|}|name: |age: |email:"), ""); // webfun, subscribe
          g.trim();

         databaseReferenceUsersList = g.split(','); // [webfun,  subscribe}]

          return GestureDetector(
            onTap: () {
              setState(() {
                userKey = snapshot.key;
              });

              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Update user information"),
                  content: Column(children: [
                    // email
                    Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: emailController..text = databaseReferenceUsersList[2],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                    // name
                    Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: nameController..text = databaseReferenceUsersList[0],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                  ),

                  //age
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: ageController..text = databaseReferenceUsersList[1],
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Age',
                      ),
                    ),
                  ),
                  ],),
                  
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await updateUserInfo();
                        Navigator.of(ctx).pop();
                      },
                      color: Color.fromARGB(255, 0, 22, 145),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.indigo[100],
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 0, 0),
                    ),
                    onPressed: () {
                      databaseReferenceUsers.child(snapshot.key!).remove();
                    },
                  ),
                  title: Text(
                    databaseReferenceUsersList[2],
                    // 'dd',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(children: [
                    // name
                    Text(
                    databaseReferenceUsersList[0],
                    // 'dd',

                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // age
                  Text(
                    databaseReferenceUsersList[1],
                    // 'dd',

                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ],)
                ),
              ),
            ),
          );
        },
      ),

            // todos
            FirebaseAnimatedList(
              query: ref,
              shrinkWrap: true,
              itemBuilder: (context, snapshot, animation, index) {
                print(snapshot.value);
                var v = snapshot.value
                    .toString(); // {subtitle: webfun, title: subscribe}
                print(v);

                g = v.replaceAll(
                    RegExp("{|}|subtitle: |title: "), ""); // webfun, subscribe
                g.trim();

                l = g.split(','); // [webfun,  subscribe}]

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      k = snapshot.key;
                    });

                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: second,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'title',
                            ),
                          ),
                        ),
                        content: Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: TextField(
                            controller: third,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'sub title',
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            color: Color.fromARGB(255, 0, 22, 145),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              await upd();
                              Navigator.of(ctx).pop();
                            },
                            color: Color.fromARGB(255, 0, 22, 145),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.indigo[100],
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 255, 0, 0),
                          ),
                          onPressed: () {
                            ref.child(snapshot.key!).remove();
                          },
                        ),
                        title: Text(
                          l[1],
                          // 'dd',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          l[0],
                          // 'dd',

                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("todos/$k");

// Only update the name, leave the age and address!
    await ref1.update({
      "title": second.text,
      "subtitle": third.text,
    });
    second.clear();
    third.clear();
  }

  updateUserInfo() async {
    DatabaseReference databaseReferenceUsersUpdate = FirebaseDatabase.instance.ref("users/$userKey");

// Only update the name, leave the age and address!
    await databaseReferenceUsersUpdate.update({
      "email": emailController.text,
      "name": nameController.text,
      "age": ageController.text,
    });
    emailController.clear();
    nameController.clear();
    ageController.clear();
  }
}
