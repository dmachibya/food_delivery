import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/app_drawer.dart';

import 'food_details.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomHomeDrawer(),
      appBar: AppBar(title: Text("Audiobooks App")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.black),
            ),
            Text(
              "Here are the available books",
            ),
            SizedBox(
              height: 12,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("books").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // hasMessage = true;
                    // message = "Loading";
                    return Text("Loading...");
                    // setMessage("Loading data");
                  }
                  if (!snapshot.hasData) {
                    return Icon(Icons.info, size: 32);
                  } else if (snapshot.hasError) {
                    return Icon(Icons.warning, size: 32);
                  } else if (snapshot.data!.docs.length < 1) {
                    return Text("No books found");
                  }

                  var list = snapshot.data!.docs;

                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(list.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return FoodDetails(
                                  item: list[index],
                                );
                              })));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 4),
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade200),
                              // height: 350,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  list[index]
                                          .data()
                                          .toString()
                                          .contains('cover')
                                      ? Image.network(list[index].get('cover'),
                                          height: 80,
                                          width: double.infinity,
                                          fit: BoxFit.cover)
                                      : Container(),
                                  // SizedBox(height: 10),
                                  Container(
                                    // height: 250,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index].get('name'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          "Genres: ${list[index].get('genres')}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          "Author: ${list[index].get('author')}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
