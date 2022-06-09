import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:park_benching/routes/routes.dart';
import 'package:park_benching/view/constant/app_styling.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: "Parkbenching",
      themeMode: ThemeMode.light,
      theme: AppStyling.styling,
      initialRoute: AppLinks.splashScreen,
      getPages: AppRoutes.routes,
    );
  }
}

