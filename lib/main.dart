import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // check error
        if (snapshot.hasError) {
          print('Something went wrong');
        }
        // once completed, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Firebase CRUD',
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
