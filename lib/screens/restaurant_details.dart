import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/auth.dart';

class RestaurantDetails extends StatefulWidget {
  RestaurantDetails({Key? key}) : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  bool isEditable = false;

  final db = FirebaseFirestore.instance;

  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurant Details")),
      body: Container(
        child: FutureBuilder(
            future: futureStore(),
            builder: (context, snapshot) {
              // print(snapshot);
              if (snapshot.hasError)
                return Text("There was an error -- ${snapshot.error}");
              if (!snapshot.hasData) return Text("No data found");

              // print("snapshot");

              final data = snapshot.data as Map<String, dynamic>;
              // print(data['email']);
              // print(snapshot.data['email']);
              // print(snapshot.data['email']);
              storeLocationController.text = data['restaurant_location'];
              storeNameController.text = data['restaurant_name'];
              return Form(
                key: _key,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(children: [
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditable = true;
                              });
                            },
                            child: Text("Edit Details"))
                      ],
                    ),
                    TextFormField(
                      controller: storeNameController,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Store Name")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: storeLocationController,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Store Location")),
                    ),
                    Spacer(),
                    ElevatedButton(
                        onPressed: isEditable
                            ? () {
                                db
                                    .collection("users")
                                    .doc(AuthHelper().user!.uid)
                                    .update({
                                  'restaurant_location':
                                      storeLocationController.text,
                                  'restaurant_name': storeNameController.text
                                }).then((value) => {
                                          setState(() => {isEditable = false})
                                        });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                          // enabled: isEditable,
                        ),
                        child: Text("Update Details"))
                  ]),
                ),
              );
            }),
      ),
    );
  }
}
