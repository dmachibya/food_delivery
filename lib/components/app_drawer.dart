import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// import 'package:big_cart/app/app.router.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../utils/auth.dart';

class CustomHomeDrawer extends StatefulWidget {
  CustomHomeDrawer({Key? key}) : super(key: key);

  @override
  State<CustomHomeDrawer> createState() => _CustomHomeDrawerState();
}

class _CustomHomeDrawerState extends State<CustomHomeDrawer> {
  File? _photo;
  // this variable used to store the future _fetchData function inorder to avoid loop on a future builder
  // late final Future? _fetchDataFuture;
  //image url variable
  String profileImageUrl = '';
  final ImagePicker _picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var name = AuthHelper().user.uid;

  Map<String, dynamic> userObject = {};
  final db = FirebaseFirestore.instance;

  // @override
  @override
  void initState() {
    super.initState();
    //initialize the variable with the future function
    // _fetchDataFuture = _fetchData();
    initValues();
  }

  void initValues() async {
    await db
        .collection("users")
        .doc(AuthHelper().user.uid)
        .get()
        .then((snapshot) => {userObject = snapshot.data()!});
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '/';
    var temp = _photo!.path.split(".");
    var extension = temp[temp.length - 1];
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(name + "." + extension);
      var uploadTask = ref.putFile(_photo!);

      await uploadTask.whenComplete(() {
        ref.getDownloadURL().then((value) {
          db.collection("users").doc(name).update({'photo': value});
          setState(() {
            profileImageUrl = value;
          });
        });
      });
    } catch (e) {
      print('error occured while uploading image ' + e.toString());
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: FutureBuilder(
                  future:
                      db.collection("users").doc(AuthHelper().user.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text("loading...");
                      default:
                        if (snapshot.hasError) {
                          return Text("There was an error");
                        } else {
                          var item_data = snapshot.data;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    child: Row(children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Stack(
                                      children: [
                                        Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: profileImageUrl == ''
                                                ? snapshot.data!.get('photo') ==
                                                        ""
                                                    ? Icon(Icons.person,
                                                        size: 32)
                                                    : ClipRRect(
                                                        child: Image.network(
                                                            snapshot.data!
                                                                .get("photo")),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60))
                                                : ClipRRect(
                                                    child: Image.network(
                                                        profileImageUrl),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60))),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: InkWell(
                                              onTap: () {
                                                imgFromGallery();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  color: Colors.grey.shade700,
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item_data!.get('name'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        Text(
                                          item_data!.get('role') == null
                                              ? "Unknown"
                                              : item_data['role'] == 0
                                                  ? 'Customer Account'
                                                  : item_data['role'] == 1
                                                      ? 'Restaurant Account'
                                                      : 'Admin Account',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.blue),
                                        )
                                      ])
                                ]))
                              ]);
                        }
                    }
                  }),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pop(context);
          //     GoRouter.of(context).go("/home/cart/1");
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => ShoppingCartView(main: false)));
          //   },
          //   leading: const Icon(
          //     Icons.shopping_cart,
          //     color: Colors.grey,
          //   ),
          //   title: Text(
          //     'Cart',
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline6!
          //         .copyWith(color: Colors.grey),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pop(context);
          //     GoRouter.of(context).go("/restaurant");
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => ShoppingCartView(main: false)));
          //   },
          //   leading: const Icon(
          //     Icons.storefront_rounded,
          //     color: Colors.grey,
          //   ),
          //   title: Text(
          //     'Your Restaurant',
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline6!
          //         .copyWith(color: Colors.grey),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => Container()));
          //   },
          //   leading: const Icon(
          //     Icons.payments,
          //     color: Colors.grey,
          //   ),
          //   title: Text(
          //     'Your purchases',
          //     style: Theme.of(context)
          //         .textTheme
          //         .headline6!
          //         .copyWith(color: Colors.grey),
          //   ),
          // ),
          // AuthHelper().isAdmin
          //     ? ListTile(
          //         onTap: () {
          //           Navigator.pop(context);
          //           GoRouter.of(context).go("/home/admin");
          //           // Navigator.push(context,
          //           //     MaterialPageRoute(builder: (context) => ShoppingCartView(main: false)));
          //         },
          //         leading: const Icon(
          //           Icons.notes,
          //           color: Colors.grey,
          //         ),
          //         title: Text(
          //           'Admin Panel',
          //           style: Theme.of(context)
          //               .textTheme
          //               .headline6!
          //               .copyWith(color: Colors.grey),
          //         ),
          //       )
          //     : Container(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              FocusManager.instance.primaryFocus?.unfocus();
              AuthHelper().signOut().then((value) {
                GoRouter.of(context).go("/login");
              });
              // viewModel.logoutUser();
            },
            leading: const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
