import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
CollectionReference benchesCollection = FirebaseFirestore.instance.collection("benches");
CollectionReference reportsCollection = FirebaseFirestore.instance.collection("reports");
CollectionReference parksCollection = FirebaseFirestore.instance.collection("parks");

customToast(String msg) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    fontSize: 16.0);

double calculateDistance({required double lat1, required double lon1, required double lat2, required double lon2}) {
  var pi = 0.017453292519943295;
  var a = 0.5 - cos((lat2 - lat1) * pi) / 2 + cos(lat1 * pi) * cos(lat2 * pi) * (1 - cos((lon2 - lon1) * pi)) / 2;
  return (12742 * asin(sqrt(a))) * 1000;
}

String meterIntoKm(double meter) {
  if (meter < 1000) {
    int? distanceInMeter = meter.toInt();
    return "${distanceInMeter}m";
  } else {
    meter = meter / 1000;
    return "${meter}Km";
  }
}
