import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../utils/auth.dart';
import 'add_food_screen.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantScreen extends StatefulWidget {
  RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  // final db = Firestore.instance;
  final db = FirebaseFirestore.instance;
  var listOfWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text("Products"),
        actions: [
          InkWell(
              onTap: () {
                GoRouter.of(context).go("/");
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  decoration: BoxDecoration(color: Colors.teal),
                  child: Row(children: [
                    Icon(Icons.add, color: Colors.white),
                    Text(
                      "New Product",
                      style: TextStyle(color: Colors.white),
                    )
                  ])))
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(top: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text("Your produts",
                  style: Theme.of(context).textTheme.headline6),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection("products")
                    .where('uid', isEqualTo: AuthHelper().user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("No Data..."),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("There was an error..."),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("Loading..."),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Text("No products available"));
                  }
                  return ListView.separated(
                      itemBuilder: ((context, index) {
                        // print("data begins");
                        var item = snapshot.data!.docs[index];
                        // print(snapshot.data!.docs.);
                        // print("data ends");
                        return GestureDetector(
                            child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          child: Row(children: [
                            Text(item.data().toString().contains('name')
                                ? item.get('name')
                                : ''),
                            Spacer(),
                            AppPopupMenu(
                              menuItems: const [
                                PopupMenuItem(
                                  value: 2,
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Text('Delete'),
                                ),
                              ],
                              // initialValue: 2,
                              onSelected: (int value) {
                                print("selected");
                                print(item.id);
                                if (value == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddFoodScreen(item: item)));
                                } else if (value == 3) {
                                  print("here inside");
                                  db
                                      .collection("products")
                                      .doc(item.id)
                                      .delete();
                                }
                              },
                              icon: Icon(Icons.more_vert_outlined),
                            )
                          ]),
                        ));
                      }),
                      separatorBuilder: ((context, index) => Divider()),
                      itemCount: snapshot.data!.docs.length);
                },
              ),
            )
          ])),
    );
  }
}
