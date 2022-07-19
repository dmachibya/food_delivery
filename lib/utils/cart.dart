import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/auth.dart';

class Cart {
  final db = FirebaseFirestore.instance;

  Future<void> addItem(product_id, name, quantity, price, owner, picking_option,
      picking_center) async {
    await db.collection("cart").add({
      "product_id": product_id,
      "product_name": name,
      "quantity": quantity,
      "price": price,
      "status": "0", // 0 unchecked // 1 checked out
      "payment_status": 0, // 0 pending // 1 approved // -1 denied
      "picking_center": picking_center,
      "picking_option": picking_option,
      "owned_by": owner,
      "uid": AuthHelper().user.uid,
    });
  }

  Future<void> completeCheckout(total, img) async {
    QuerySnapshot lists = await db
        .collection("cart")
        .where("uid", isEqualTo: AuthHelper().user.uid)
        .where("status", isEqualTo: "0")
        .get();

    print("lists");
    print(lists.docs[0]['price']);
    // var list =  lists.map((event) => event).toList();
    var items = [];
    var cartIds = [];

    for (var element in lists.docs) {
      // print("element");
      await db.collection("cart").doc(element.id).update({"status": 1});
      items.add(element.get('product_id'));
      cartIds.add(element.id);
      // print(element);
    }
    var today = DateTime.now();
    db.collection("payments").add({
      "uid": AuthHelper().user.uid,
      "dateTime": today.toString(),
      "image": img,
      "status": 0,
      "total": total,
      "products": items,
      "cart_items": cartIds
    });
  }

  Future<bool> paymentApproveOrDeny(status, paymentId) async {
    await db
        .collection("payments")
        .doc(paymentId)
        .update({"status": 1}).onError((error, stackTrace) => false);

    //updating the payment status in each cart item
    DocumentSnapshot paymentDoc =
        await db.collection("payments").doc(paymentId).get();

    for (var element in paymentDoc.get("cart_items")) {
      await db.collection("cart").doc(element).update({
        "payment_status": status,
        "payment_date": paymentDoc.get('dateTime'),
        "payment_id": paymentId
      });
    }
    // QuerySnapshot lists = await db
    //     .collection("cart")
    //     .where("uid", isEqualTo: AuthHelper().user.uid)
    //     .where("status", isEqualTo: "0")
    //     .get();

    return true;
  }
}
