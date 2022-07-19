import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../components/app_drawer.dart';
import '../utils/auth.dart';
import '../utils/cart.dart';

class CartListScreen extends StatefulWidget {
  CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CartListScreen> {
  var size, height, width;
  var paddingRatio = 0.068;

  final db = FirebaseFirestore.instance;

  int priceCheckout = 0;

  final GlobalKey<FormState> _formKey = GlobalKey();
  var images = [
    'https://unsplash.com/photos/0tgMnMIYQ9Y/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OHx8aW1hZ2UlMjBwbGFpbiUyMHdoaXRlfGVufDB8fHx8MTY1NDE1OTgyOQ&force=true&w=640'
  ];

  final ImagePicker _picker = ImagePicker();
  File? img1;

  bool isImg1 = false;

  String img1Name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkTotal();
  }

  void checkTotal() async {}

  String errorMsg = "";

  // Future imgFromGallery(number) async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   final fileName = basename(pickedFile!.path);
  //   final destination = '/';
  //   var temp = pickedFile!.path.split(".");
  //   var extension = temp[temp.length - 1];

  //   setState(() {
  //     if (pickedFile != null) {
  //       switch (number) {
  //         case 1:
  //           img1 = File(pickedFile.path);
  //           isImg1 = true;
  //           img1Name = DateTime.now().millisecondsSinceEpoch.toString() +
  //               AuthenticationHelper().user.uid +
  //               "." +
  //               extension;

  //           break;

  //         default:
  //       }
  //       // _photo = File(pickedFile.path);
  //       // uploadFile();
  //     } else {
  //       print('No image selected.');
  //      });
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    // SumProvider dataProvider = Provider.of<SumProvider>(context);

    // Provider.of<SumProvider>(context, listen: false).checkTotal();

    return Scaffold(
      endDrawer: CustomHomeDrawer(),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection("cart")
                    .where("uid", isEqualTo: AuthHelper().user.uid)
                    .where("status", isEqualTo: "0")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        child: Text("No records available"));
                  }
                  return Column(
                    children: [
                      returnTotal(snapshot.data!.docs),
                      Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              var item = snapshot.data!.docs[index];

                              var sum_amount = 0;

                              return StreamBuilder<DocumentSnapshot>(
                                  stream: db
                                      .collection("products")
                                      .doc(item.get('product_id'))
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: const Text("Loading..."),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: const Text("There was an error"),
                                      );
                                    }

                                    var doc = snapshot.data;

                                    // setState(() {
                                    //   total = int.parse(item.get('quantity')) *
                                    //       int.parse(doc!.get('price'));
                                    // });
                                    sum_amount +=
                                        int.parse(item.get('quantity')) *
                                            int.parse(doc!.get('price'));

                                    return Card(
                                      child: Container(
                                          padding: EdgeInsets.all(12),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: 60,
                                                  width: 60,
                                                  child: Image.network(
                                                    doc
                                                            .data()
                                                            .toString()
                                                            .contains('img1')
                                                        ? doc.get('img1') != ''
                                                            ? doc.get('img1')
                                                            : images[0]
                                                        : images[0],
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )),
                                              SizedBox(width: 10),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      doc.get('name'),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        "Quantity: ${item.get('quantity')}"),
                                                    Text(
                                                        "Price: TZS ${doc.get('price')}"),
                                                    Text(
                                                      "Total: TZS ${int.parse(item.get('quantity')) * int.parse(doc.get('price'))}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.teal),
                                                    ),
                                                  ]),
                                              Spacer(),
                                              AppPopupMenu(
                                                menuItems: const [
                                                  PopupMenuItem(
                                                    value: 3,
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                                // initialValue: 2,
                                                onSelected: (int value) {
                                                  print("selected");
                                                  // print(item.id);
                                                  if (value == 1) {
                                                    // Navigator.pushNamed(
                                                    //     context, adminProductDetailsRoute);
                                                  } else if (value == 3) {
                                                    // print("here inside");
                                                    db
                                                        .collection("cart")
                                                        .doc(item.id)
                                                        .delete();
                                                  }
                                                },
                                                icon: Icon(
                                                    Icons.more_vert_outlined),
                                              )
                                            ],
                                          )),
                                    );
                                  });
                            })),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCartBottomSheet(context, total) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // SumProvider dataProvider = Provider.of<SumProvider>(context);

          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Checkout Now",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Pay the required amount through M-PESA, LIPA NUMBER: 111 222 (NAME: ARUSHA MERCHANTS), then upload payment sms screenshot below"),
                      SizedBox(height: 12),
                      Text(
                        "TZS $total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      const Text("Upload Payment Information"),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          final pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);

                          final fileName = basename(pickedFile!.path);
                          final destination = '/';
                          var temp = pickedFile!.path.split(".");
                          var extension = temp[temp.length - 1];

                          setModalState(() {
                            if (pickedFile != null) {
                              switch (1) {
                                case 1:
                                  img1 = File(pickedFile.path);
                                  isImg1 = true;
                                  img1Name = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString() +
                                      AuthHelper().user.uid +
                                      "." +
                                      extension;

                                  break;

                                default:
                              }
                              // _photo = File(pickedFile.path);
                              // uploadFile();
                            } else {
                              print('No image selected.');
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          width: double.infinity,
                          height: 100,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade300),
                          child: isImg1
                              ? Image.file(
                                  img1!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.photo_camera,
                                ),
                        ),
                      ),
                      Text(
                        errorMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () async {
                            if (img1 != null) {
                              final ref = firebase_storage
                                  .FirebaseStorage.instance
                                  .ref("/")
                                  .child(img1Name);
                              var uploadTask = ref.putFile(img1!);

                              await uploadTask.whenComplete(() {
                                ref.getDownloadURL().then((value) {
                                  Cart().completeCheckout(
                                      total, value.toString());

                                  // db
                                  //     .collection("products")
                                  //     .doc(doc)
                                  //     .update({"img1": value.toString()});
                                });
                              });
                              // checkTotal();
                              // setModalState(() {
                              //   total = 0;
                              // });
                              // dataProvider.checkTotal();
                              // Provider.of<SumProvider>(context, listen: false)
                              //     .checkTotal();
                              // ;
                              Navigator.pop(context);
                            } else {
                              setModalState(() {
                                errorMsg = "Please attach payment image";
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50), // NEW
                            // enabled: isEditable,
                          ),
                          child: Text("Complete Checkout"))
                    ],
                  )),
            );
          });
        });
  }

  Widget returnTotal(docs) {
    var total = 0;
    for (var element in docs) {
      // print("element");
      total +=
          int.parse(element.get('price')) * int.parse(element.get('quantity'));
      // print(element);
    }

    return Container(
      child: Container(
          height: 60,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: width * paddingRatio),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text.rich(TextSpan(text: "Total:", children: [
              TextSpan(
                  text: " TZS $total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ])),
            DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.pink.shade700,
                      Colors.pink.shade500,
                      Colors.pink.shade300,
                      //add more colors
                    ]),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color:
                              Color.fromRGBO(0, 0, 0, 0.3), //shadow for button
                          blurRadius: 5) //blur radius of shadow
                    ]),
                child: Builder(builder: (context) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        //make color or elevated button transparent
                      ),
                      onPressed: () {
                        // ScaffoldMessenger.of(context).show

                        _addToCartBottomSheet(context, total);
                      },
                      child: Text("Checkout"));
                })),
          ])),
    );
  }
}

class SumProvider extends ChangeNotifier {
  int total = 1000;

  final db = FirebaseFirestore.instance;

  void checkTotal() async {
    QuerySnapshot lists = await db
        .collection("cart")
        .where("uid", isEqualTo: AuthHelper().user.uid)
        .where("status", isEqualTo: "0")
        .get();

    // var list =  lists.map((event) => event).toList();
    for (var element in lists.docs) {
      // print("element");
      total +=
          int.parse(element.get('price')) * int.parse(element.get('quantity'));
      // print(element);
    }

    total = total + 0;
    print("total $total");
    notifyListeners();
  }
}
