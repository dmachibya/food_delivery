import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils/auth.dart';

class AddFoodScreen extends StatefulWidget {
  final item;

  AddFoodScreen({Key? key, this.item}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  var size, height, width;
  var paddingRatio = 0.068;

  final userId = AuthHelper().user.uid;

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  final db = FirebaseFirestore.instance;

  Future<bool?> _create() async {
    // return false;
  }
  final ImagePicker _picker = ImagePicker();
  File? img1;
  File? img2;
  File? img3;

  bool isImg1 = false;
  bool isImg2 = false;
  bool isImg3 = false;

  String img1Name = "";
  String img2Name = "";
  String img3Name = "";

  bool submitted = false;
  bool isEditing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();

    if (widget.item != null) {
      isEditing = true;

      productDescriptionController.text = widget.item.get('description');
      quantityController.text = widget.item.get('quantity');
      priceController.text = widget.item.get('price');
      productNameController.text = widget.item.get('name');
    }
  }

  dynamic current_user = null;

  Future getUserDetails() async {
    DocumentSnapshot user = await db
        .collection("users")
        .doc(AuthHelper().user.uid)
        .get()
        .then((value) {
      setState(() {
        current_user = value;
      });
      return value;
    });

    return user;
  }

  Future imgFromGallery(number) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    final fileName = basename(pickedFile!.path);
    final destination = '/';
    var temp = pickedFile!.path.split(".");
    var extension = temp[temp.length - 1];

    setState(() {
      if (pickedFile != null) {
        switch (number) {
          case 1:
            img1 = File(pickedFile.path);
            isImg1 = true;
            img1Name = DateTime.now().millisecondsSinceEpoch.toString() +
                userId +
                "." +
                extension;
            break;
          case 2:
            img2 = File(pickedFile.path);
            img2Name = DateTime.now().millisecondsSinceEpoch.toString() +
                userId +
                "." +
                extension;
            isImg2 = true;
            break;
          case 3:
            img3 = File(pickedFile.path);
            img3Name = DateTime.now().millisecondsSinceEpoch.toString() +
                userId +
                "." +
                extension;

            isImg3 = true;
            break;
          default:
        }
        // _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFiles(doc) async {
    // if (_photo == null) return;
    // final fileName = basename(_photo!.path);
    // final destination = '/';
    // var temp = _photo!.path.split(".");
    // var extension = temp[temp.length - 1];
    try {
      if (isImg1) {
        final ref =
            firebase_storage.FirebaseStorage.instance.ref("/").child(img1Name);
        var uploadTask = ref.putFile(img1!);

        await uploadTask.whenComplete(() {
          ref.getDownloadURL().then((value) {
            db
                .collection("products")
                .doc(doc)
                .update({"img1": value.toString()});
          });
        });
        // url = dowurl.toString();

      }

      if (isImg2) {
        final ref2 =
            firebase_storage.FirebaseStorage.instance.ref("/").child(img2Name);
        await ref2.putFile(img2!);
        await db
            .collection("products")
            .doc(doc)
            .update({"img2": ref2.getDownloadURL()});
      }
      if (isImg3) {
        final ref3 =
            firebase_storage.FirebaseStorage.instance.ref("/").child(img3Name);
        await ref3.putFile(img3!);

        await db
            .collection("products")
            .doc(doc)
            .update({"img3": ref3.getDownloadURL()});
      }
      // db
      //     .collection("users")
      //     .doc(name)
      //     .update({'photo': name + '.' + extension});
    } catch (e) {
      print('error occured while uploading image ' + e.toString());
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text("New Product")),
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: width * paddingRatio),
          child: current_user != null
              ? Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: Row(
                        children: [
                          Icon(Icons.inventory_2, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: productNameController,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter product name '
                                  : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text("Product Name")),
                            ),
                          )
                        ],
                      )),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              textAlignVertical: TextAlignVertical.top,
                              keyboardType: TextInputType.text,
                              controller: productDescriptionController,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter product description '
                                  : null,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.segment, color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  label: Text("Description",
                                      textAlign: TextAlign.start)),
                            ),
                          )
                        ],
                      )),
                      Divider(),
                      Divider(),
                      Container(
                          child: Row(
                        children: [
                          Icon(Icons.inventory_2, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter quantity '
                                  : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text("Quantity")),
                            ),
                          )
                        ],
                      )),
                      Divider(),
                      Container(
                          child: Row(
                        children: [
                          Icon(Icons.payments_outlined, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: priceController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter price ' : null,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  label: Text("Price")),
                            ),
                          )
                        ],
                      )),
                      Divider(),
                      SizedBox(height: 20),
                      Text(
                        "Pictures",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      Container(
                          child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              imgFromGallery(1);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 80,
                              height: 80,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade300),
                              child: isImg1
                                  ? Image.file(
                                      img1!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : isEditing
                                      ? widget.item.get('img1') != ""
                                          ? Image.network(
                                              widget.item.get('img1'),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.photo_camera,
                                            )
                                      : Icon(Icons.photo_camera),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              imgFromGallery(2);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 80,
                              height: 80,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade300),
                              child: isImg2
                                  ? Image.file(
                                      img2!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : isEditing
                                      ? widget.item.get('img2') != ""
                                          ? Image.network(
                                              widget.item.get('img2'),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.photo_camera,
                                            )
                                      : Icon(Icons.photo_camera),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              imgFromGallery(3);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 80,
                              height: 80,
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade300),
                              child: isImg3
                                  ? Image.file(
                                      img3!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : isEditing
                                      ? widget.item.get('img3') != ""
                                          ? Image.network(
                                              widget.item.get('img3'),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.photo_camera,
                                            )
                                      : Icon(Icons.photo_camera),
                            ),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 24,
                      ),
                      isEditing
                          ? ElevatedButton(
                              onPressed: !submitted
                                  ? () async {
                                      setState(() {
                                        submitted = true;
                                      });
                                      if (formKey.currentState!.validate()) {
                                        // _is_loading ? null : _executeLogin();
                                        await _products
                                            .doc(widget.item.id)
                                            .update({
                                          "name": productNameController.text,
                                          "description":
                                              productDescriptionController.text,
                                          "quantity": quantityController.text,
                                          "img1": img1Name != ""
                                              ? img1Name
                                              : widget.item.get('img1'),
                                          "img2": img2Name != ""
                                              ? img3Name
                                              : widget.item.get('img2'),
                                          "img3": img3Name != ""
                                              ? img3Name
                                              : widget.item.get('img3'),
                                          "price": priceController.text,
                                        }).then((documentReference) {
                                          // print("success");
                                          // return true;
                                          setState(() {
                                            submitted = false;
                                          });
                                          // if (img1Name == "" &&
                                          //     img2Name == "" &&
                                          //     img3Name == "") {
                                          // GoRouter.of(context)
                                          //     .go(productRouteFull);
                                          // }
                                          uploadFiles(widget.item.id)
                                              .then((value) {
                                            // GoRouter.of(context)
                                            //     .go(productRouteFull);
                                            // Navigator.of(context).push()
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Container()));
                                            print("success here");
                                          });
                                          // print(documentReference!.documentID);
                                          // clearForm();
                                        }).catchError((e) {
                                          setState(() {
                                            submitted = false;
                                          });
                                          print(e);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "There was an error, make sure you have internet connection")));
                                          // return false;
                                        });
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50), // NEW
                                // enabled: isEditable,
                              ),
                              child: Text(
                                "Update Product",
                              ),
                            )
                          : ElevatedButton(
                              onPressed: !submitted
                                  ? () {
                                      setState(() {
                                        submitted = true;
                                      });
                                      if (formKey.currentState!.validate()) {
                                        // _is_loading ? null : _executeLogin();
                                        _products.add({
                                          "name": productNameController.text,
                                          "description":
                                              productDescriptionController.text,
                                          "quantity": quantityController.text,
                                          "img1": img1Name,
                                          "img2": img2Name,
                                          "img3": img3Name,
                                          "price": priceController.text,
                                          "uid": current_user['uid'],
                                          "store": current_user['store_name'],
                                        }).then((documentReference) {
                                          // print("success");
                                          // return true;
                                          setState(() {
                                            submitted = false;
                                          });
                                          uploadFiles(documentReference!.id)
                                              .then((value) {
                                            print("print");
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Container()));
                                          });
                                          // print(documentReference!.documentID);
                                          // clearForm();
                                        }).catchError((e) {
                                          setState(() {
                                            submitted = false;
                                          });
                                          print(e);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "There was an error, make sure you have internet connection")));
                                          // return false;
                                        });
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50), // NEW
                                // enabled: isEditable,
                              ),
                              child: Text(
                                "Add Product",
                              ),
                            ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
              : Text("Please wait... "),
        );
      }),
    );
  }
}
