// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/app_drawer.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../utils/cart.dart';

class FoodDetails extends StatefulWidget {
  dynamic item;
  FoodDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  var size, height, width;
  var paddingRatio = 0.068;

  //picking center
  String? pickingCenter = "Mianzini Center";
  bool isPickingFromCenter = false;

  bool addedToCart = false;

  var images = [
    'https://unsplash.com/photos/0tgMnMIYQ9Y/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OHx8aW1hZ2UlMjBwbGFpbiUyMHdoaXRlfGVufDB8fHx8MTY1NDE1OTgyOQ&force=true&w=640'
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController quantityController;
  //firestore instance

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController = TextEditingController(text: "1");
  }

  final db = FirebaseFirestore.instance;

  var dropDownValue = '1. Pick from the merchant';
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    var checkedValue = "";
    PageController _pageController = PageController(viewportFraction: 0.8);
    // const List<String> _kOptions = <String>[
    //   'aardvark',
    //   'bobcat',
    //   'chameleon',
    // ];

    // // add images to pageview
    // if (widget.item.data().toString().contains('img1') &&
    //     widget.item.get('img1') != '') {
    //   images[0] = widget.item.get('img1');
    // }
    // if (widget.item.data().toString().contains('img2') &&
    //     widget.item.get('img2') != '') {
    //   images.add(widget.item.get('img2'));
    // }
    // if (widget.item.data().toString().contains('img3') &&
    //     widget.item.get('img3') != '') {
    //   images.add(widget.item.get('img3'));
    // }

    // var item_price = widget.item.data().toString().contains('price')
    //     ? widget.item.get('price')
    //     : '';
    // var item_name = widget.item.data().toString().contains('name')
    //     ? widget.item.get('name')
    //     : '';
    // var item_owner = widget.item.data().toString().contains('uid')
    //     ? widget.item.get('uid')
    // : '';
    // var item_price = widget.item.data().toString().contains('price')
    //     ? widget.item.get('price')
    //     : '';

    GlobalKey formKey = GlobalKey();
    return Scaffold(
      endDrawer: CustomHomeDrawer(),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title:
              Text("Arusha Merchants", style: TextStyle(color: Colors.black)),
          actions: [
            Builder(
              builder: (BuildContext context) => IconButton(
                  icon: const Icon(Icons.menu_outlined),
                  color: Colors.black,
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  }),
            )
          ]),
      body: FutureBuilder(
          future: db.collection("products").doc(widget.item).get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text("Loading..."),
              );
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(28.0),
                child: Text("There was an eror"),
              );
            }

            if (!snapshot.hasData) {
              return const Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text("No Data Available"),
              );
            }

            var slides = [];
            slides.add(images[0]);

            var item = snapshot.data;
            if (item!['img1'] != '') {
              slides[0] = item['img1'];
            }
            if (item!['img2'] != '') {
              slides[0] = item['img2'];
            }
            if (item!['img3'] != '') {
              slides[0] = item['img3'];
            }

            return Container(
                padding: EdgeInsets.only(bottom: 60),
                child: ListView(children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * paddingRatio,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TZS ${item['price']}",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${item['name']}",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${item['category']}",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Picking up details",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("How would you prefer to pick this item?"),
                          DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(60)),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    value: dropDownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    onChanged: (String? newValue) {
                                      if (newValue ==
                                          '2. Picking from a centre') {
                                        setState(() {
                                          isPickingFromCenter = true;
                                        });
                                      }

                                      setState(() {
                                        dropDownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      '1. Pick from the merchant',
                                      '2. Picking from a centre'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      )),
                ]));
          }),
      bottomSheet: FutureBuilder(
          future: db.collection("products").doc(widget.item).get(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("There was an eror");
            }
            if (!snapshot.hasData) {
              return Text("No Data Available");
            }
            var item = snapshot.data;
            return Container(
              height: 60,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: width * paddingRatio),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //     icon: Icon(Icons.store_mall_directory_outlined),
                  //     onPressed: () {}),
                  Expanded(
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.pink.shade700,
                              Colors.pink.shade500,
                              Colors.pink.shade300,
                              //add more colors
                            ]),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromRGBO(
                                      0, 0, 0, 0.3), //shadow for button
                                  blurRadius: 5) //blur radius of shadow
                            ]),
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                onSurface: Colors.transparent,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size.fromHeight(50),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                //make color or elevated button transparent
                              ),
                              onPressed: () {
                                // ScaffoldMessenger.of(context).show
                                setState(() {
                                  addedToCart = false;
                                });
                                _addToCartBottomSheet(
                                    context,
                                    item!['name'],
                                    item['price'],
                                    item['uid'],
                                    item!['img1'],
                                    item.id);
                              },
                              child: Text("Add to Cart"));
                        })),
                  ),
                  // DecoratedBox(
                  //     decoration: BoxDecoration(
                  //         gradient: LinearGradient(colors: [
                  //           Colors.teal,
                  //           Colors.teal.shade300,
                  //           //add more colors
                  //         ]),
                  //         borderRadius: BorderRadius.circular(30),
                  //         boxShadow: const <BoxShadow>[
                  //           BoxShadow(
                  //               color:
                  //                   Color.fromRGBO(0, 0, 0, 0.3), //shadow for button
                  //               blurRadius: 5) //blur radius of shadow
                  //         ]),
                  //     child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Colors.transparent,
                  //           onSurface: Colors.transparent,
                  //           shadowColor: Colors.transparent,
                  //           padding:
                  //               EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  //           //make color or elevated button transparent
                  //         ),
                  //         onPressed: () {},
                  //         child: Text("Buy Now"))),
                ],
              ),
            );
          }),
    );
  }

  void _addToCartBottomSheet(context, name, price, owner, image, id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            // setState(() {
            //   addedToCart = false;
            // });
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: !addedToCart
                  ? Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add to Cart",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(image,
                                    width: 60, height: 60, fit: BoxFit.cover),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(name),
                                      Text(
                                        "TZS $price",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      )
                                    ]))
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Quantity"),
                          Row(children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    quantityController.text =
                                        (int.parse(quantityController.text) - 1)
                                            .toString();
                                  });
                                },
                                child: Icon(Icons.remove)),
                            Expanded(
                              child: TextFormField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: quantityController,
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter quantity '
                                      : null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  )),
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    quantityController.text =
                                        (int.parse(quantityController.text) + 1)
                                            .toString();
                                  });
                                },
                                child: Icon(Icons.add)),
                          ]),
                          Spacer(),
                          ElevatedButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                Cart()
                                    .addItem(
                                        id,
                                        name,
                                        quantityController.text,
                                        price,
                                        owner,
                                        dropDownValue,
                                        dropDownValue ==
                                                '1. Pick from the merchant'
                                            ? ''
                                            : pickingCenter)
                                    .then((value) {
                                  // Alert(
                                  //         context: context,
                                  //         title: "Success",
                                  //         desc:
                                  //             "The product you selected was added to card .")
                                  //     .show();
                                  setState(() {
                                    addedToCart = true;
                                  });
                                  Timer _timer;
                                  int _start = 3;

                                  void startTimer() {
                                    const oneSec = const Duration(seconds: 1);
                                    _timer = new Timer.periodic(
                                      oneSec,
                                      (Timer timer) {
                                        if (_start == 0) {
                                          setState(() {
                                            addedToCart = false;

                                            timer.cancel();
                                          });
                                        } else {
                                          setState(() {
                                            _start--;
                                          });
                                        }
                                      },
                                    );
                                  }

                                  setState(() {
                                    addedToCart = true;
                                  });
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(content: Text("Added to cart"))
                                  //     );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50), // NEW
                                // enabled: isEditable,
                              ),
                              child: Text("Add to Cart"))
                        ],
                      ))
                  : Container(
                      padding: EdgeInsets.all(28),
                      child: Text(
                        "Added to Cart successfully",
                        style: TextStyle(color: Colors.green),
                      )),
            );
          });
        });
  }
}
