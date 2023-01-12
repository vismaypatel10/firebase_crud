import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/widgets/custom_textformfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUser extends StatefulWidget {
  final String id;
  UpdateUser({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formkey = GlobalKey<FormState>();

  String? imageUrl;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> updateuser(id, name, email, password, profilepic) async {
    print(id);
    return users
        .doc(id)
        .update({
          'name': name,
          'email': email,
          'password': password,
          'Images': profilepic,
        })
        .then((value) => print('User Updated'))
        .catchError((error) => print('Failed to Update user: $error'));
  }

  File? _image;
  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    setState(() {
      if (image == null) {
        NetworkImage(
            'https://cdn4.iconfinder.com/data/icons/glyphs/24/icons_user2-256.png');
      } else {
        _image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Users Details')),
      body: Form(
        key: _formkey,
        // Getting specific data by ID
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.id)
              .get(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              print('Something went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!.data();
            var name = data!['name'];
            var email = data['email'];
            var password = data['password'];
            var profilepic = data['Images'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(children: [
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _image != null
                                  ? Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ).image
                                  : NetworkImage(profilepic.toString())),
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.1))
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                          ),
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Choose option",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        actions: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.camera_alt,
                                            ),
                                            title: Text(
                                              "Camera",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              getImage(ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.image,
                                            ),
                                            title: Text(
                                              "Gallery",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              getImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.remove_circle,
                                            ),
                                            title: Text(
                                              "Remove",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(
                                                () {
                                                  _image = null;
                                                },
                                              );
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      )
                    ]),
                    //Image.network(data['Images']),
                    SizedBox(
                      height: 20,
                    ),
                    custom_textformfield(
                      initialValue: name,
                      onChanged: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      labeltext: 'Name',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    custom_textformfield(
                      initialValue: email,
                      onChanged: (value) => email = value,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please Enter valid Email';
                        }
                        return null;
                      },
                      labeltext: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    custom_textformfield(
                      keyboardType: TextInputType.name,
                      initialValue: password,
                      onChanged: (value) => password = value,
                      maxlength: 6,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        if (password.length < 6 || password.length > 6) {
                          return 'Please Enter valid password';
                        }
                        return null;
                      },
                      labeltext: 'Password',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.maxFinite,
                        height: 55,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('user');
                                await ref.putFile(_image!);
                                imageUrl = await ref.getDownloadURL();
                                updateuser(
                                    widget.id, name, email, password, imageUrl);
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Update User ')))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
