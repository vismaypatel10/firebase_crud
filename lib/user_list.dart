import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/update_user.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Stream<QuerySnapshot> UserStream =
      FirebaseFirestore.instance.collection('Users').snapshots();

  //for delete user
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> deleteUser(id) {
    //print("User Deleted $id");
    return users
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: UserStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.all(),
              columnWidths: <int, TableColumnWidth>{1: FixedColumnWidth(150)},
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  TableCell(
                      child: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                  TableCell(
                      child: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                  TableCell(
                      child: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        'Action',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                ]),
                for (var i = 0; i < storedocs.length; i++) ...[
                  TableRow(children: [
                    TableCell(
                        child: Container(
                      child: Center(
                        child: Text(
                          storedocs[i]['name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Container(
                      child: Center(
                        child: Text(
                          storedocs[i]['email'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateUser(id: storedocs[i]['id']),
                                  ));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () => {deleteUser(storedocs[i]['id'])},
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    )),
                  ]),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
