import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getUserData() async {
    final userid = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userid!.uid)
        .get();
    print(userData.data());
    return userData.data()! ;
  }

  Future<String> login(String email, String password) async {
    String res = "error is there";
    print("Test3");
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        print("Test2");
        final sak = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(sak);
      } else {
        res = "Please Fill All the Details";
      }
    } on FirebaseAuthException catch (err) {
      print(err);
    }
    return res;
  }
}
