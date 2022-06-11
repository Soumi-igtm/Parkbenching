import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{

  final String uid;
  DatabaseServices({required this.uid});
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  Future updateUserData(String name, String email) async{
    return await usersCollection.doc(uid).set({
      "name" : name,
      "email": email,
    });
  }
  Stream<QuerySnapshot> get users{
    return usersCollection.snapshots();
  }
}