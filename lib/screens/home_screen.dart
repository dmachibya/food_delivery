import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/app_drawer.dart';

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
      appBar: AppBar(title: Text("Food Ordering System")),
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
              "Choose menu below",
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("foods").snapshots(),
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
                    return Text("No food found");
                  }

                  var list = snapshot.data!.docs;

                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(list.length, (index) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              list[index].data().toString().contains('img1')
                                  ? Image.network(list[index].get('img1'),
                                      height: 100, fit: BoxFit.cover)
                                  : Image.asset('images/cover.jpg'),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index].get('name'),
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Text(
                                      "TZS ${list[index].get('price')}",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
