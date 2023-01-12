import 'package:firebase_crud/user_list.dart';
import 'package:flutter/material.dart';

import 'add_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddUser(),
                    ));
              },
              child: Text(
                "Add User",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
      body: UserList(),
    );
  }
}
