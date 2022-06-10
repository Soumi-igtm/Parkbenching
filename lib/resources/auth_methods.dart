import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String>signUpUser({
    required String email,
    required String password,

  }) async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty ){
       await _auth.createUserWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }else {
        res = "please enter all the fields";
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }
}
