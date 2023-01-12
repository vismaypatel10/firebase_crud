import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/widgets/custom_textformfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formkey = GlobalKey<FormState>();

  var name = '';
  var email = '';
  var password = '';
  var downloadUrl = '';

  final NameController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  @override
  void dispose() {
    NameController.dispose();
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  CleanText() {
    NameController.clear();
    EmailController.clear();
    PasswordController.clear();
  }

  //Adding user data
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> adduser() async {
    //print('User Added');
    final ImageUrl = await uploadImage();
    return users
        .add({
          'name': name,
          'email': email,
          'password': password,
          'Images': ImageUrl,
        })
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to Add user: $error'));
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

  Future uploadImage() async {
    if (_image != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProfileImages')
          .child(Uuid().v1())
          .putFile(_image!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Users Details')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
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
                                  image: _image == null
                                      ? NetworkImage(
                                          'https://cdn4.iconfinder.com/data/icons/glyphs/24/icons_user2-256.png')
                                      : Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        ).image),
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
                                border:
                                    Border.all(color: Colors.black, width: 3),
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
                        const SizedBox(
                          height: 20,
                        ),
                        custom_textformfield(
                          textController: NameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Name';
                            }
                            return null;
                          },
                          labeltext: 'Name',
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        custom_textformfield(
                          keyboardType: TextInputType.emailAddress,
                          textController: EmailController,
                          labeltext: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Please Enter valid Email';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        custom_textformfield(
                          keyboardType: TextInputType.name,
                          textController: PasswordController,
                          maxlength: 6,
                          labeltext: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            if (PasswordController.text.length < 6 ||
                                PasswordController.text.length > 6) {
                              return 'Please Enter valid password';
                            }

                            return null;
                          },
                          obscureText: false,
                        ),
                        // const SizedBox(
                        //   height: 50,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      width: double.maxFinite,
                      height: 55,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                name = NameController.text;
                                email = EmailController.text;
                                password = PasswordController.text;
                                // uploadImage();
                                adduser();
                                CleanText();
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Text('Add User'))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
