import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  get isAdmin => _auth.currentUser!.email == "davidmachibya7@gmail.com";

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //SIGN UP METHOD
  Future signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = result.user!;

      users.doc(currentUser.uid).set({
        "name": name,
        "uid": currentUser.uid,
        "email": email,
        "restaurant_name": "",
        "restaurant_location": "",
        "photo":
            "https://firebasestorage.googleapis.com/v0/b/food-ordering-dc63a.appspot.com/o/avatar2.png?alt=media&token=cd956976-8961-456d-bf06-f104345ed5b9",
        "role": 0,
      }).then((documentReference) {
        // print("success");
        // return true;
        // Navigator.pushNamed(context, productRoute);
        // print(documentReference!.documentID);
        // clearForm();
      }).catchError((e) {
        return e;
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
