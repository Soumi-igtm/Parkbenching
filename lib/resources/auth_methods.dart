import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signUpUser({
    required String email,
    required String password,
}) async{
     String res = "Some error occured";
     try {
       if(email.isNotEmpty||password.isNotEmpty){
         UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
         print(cred.user!.uid);
         await _firestore.collection('users').doc(cred.user!.uid).set({
           'uid': cred.user!.uid,
           'email': email
         });
         res = 'success';
       }
     }catch (err){
       res= err.toString();
     }
     return res;
}
}