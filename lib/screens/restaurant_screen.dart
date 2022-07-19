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

  Future futureStore() async {
    DocumentSnapshot doc =
        await db.collection("users").doc(AuthHelper().user.uid).get();
    // print(doc['email']);
    // print("doc");
    final data = doc.data() as Map<String, dynamic>;
    // print(data);
    // print(jsonDecode(doc.toString()));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Restaurant"),
        ),
        body: FutureBuilder(
            future: futureStore(),
            builder: (context, snapshot) {
              // print(snapshot);
              if (snapshot.hasError)
                return Text("There was an error -- ${snapshot.error}");
              if (!snapshot.hasData) return Text("No data found");

              // return Text("There was an error");

              // print("snapshot");

              final data = snapshot.data as Map<String, dynamic>;
              // print(data['email']);
              if (data['restaurant_name'] == "") {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          "Your account is a normal account. To make it restaurant you need to set by clickup up below",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        child: Text("Set Restaurant"),
                        onPressed: () {
                          GoRouter.of(context).go('/restaurant/details');
                        },
                      ),
                    ],
                  ),
                );
              }
              // print(snapshot.data['email']);
              // print(snapshot.data['email']);
              // storeLocationController.text = data['restaurant_location'];
              // storeNameController.text = data['restaurant_name'];
              return Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Manage Restaurant"),
                        SizedBox(
                          height: 6,
                        ),
                        Wrap(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  GoRouter.of(context)
                                      .go('/restaurant/details');
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.yellow.shade700),
                                child: Text("Update Restaurant Details")),
                            SizedBox(width: 8),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green),
                                onPressed: () {},
                                child: Text("Pending Food Orders")),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue),
                                onPressed: () {},
                                child: Text("Completed Food Orders")),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(color: Colors.grey),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Text("Your Menu",
                                  style: Theme.of(context).textTheme.headline6),
                              Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .go('/restaurant/add_food');
                                  },
                                  child: Text("Add Menu")),
                            ],
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: db
                                .collection("foods")
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
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.all(28.0),
                                  child: Text("Loading..."),
                                );
                              }
                              if (snapshot.data!.docs.isEmpty) {
                                return const Padding(
                                    padding: EdgeInsets.all(28.0),
                                    child: Text("No Menu available"));
                              }
                              return ListView.separated(
                                  itemBuilder: ((context, index) {
                                    // print("data begins");
                                    var item = snapshot.data!.docs[index];
                                    // print(snapshot.data!.docs.);
                                    // print("data ends");
                                    return GestureDetector(
                                        child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 12),
                                      child: Row(children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: item
                                                    .data()
                                                    .toString()
                                                    .contains('img1')
                                                ? Image.network(
                                                    item.get('img1'),
                                                    fit: BoxFit.cover)
                                                : Image.asset(
                                                    'images/cover.jpg'),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(item
                                                .data()
                                                .toString()
                                                .contains('name')
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
                                                          AddFoodScreen(
                                                              item: item)));
                                            } else if (value == 3) {
                                              print("here inside");
                                              db
                                                  .collection("foods")
                                                  .doc(item.id)
                                                  .delete();
                                            }
                                          },
                                          icon: Icon(Icons.more_vert_outlined),
                                        )
                                      ]),
                                    ));
                                  }),
                                  separatorBuilder: ((context, index) =>
                                      Divider()),
                                  itemCount: snapshot.data!.docs.length);
                            },
                          ),
                        )
                      ]));
            }));
  }
}
