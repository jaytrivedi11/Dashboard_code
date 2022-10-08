import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/screens/DefaultScreen.dart';
import 'package:admin/screens/MangeSubDevision.dart';
import 'package:admin/screens/dashboard_screen.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLogged = prefs.containsKey("token");
  runApp(MyApp(
    isLogged: isLogged,
  ));
}

class MyApp extends StatelessWidget {
  bool isLogged;

  MyApp({required this.isLogged});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: isLogged
            ? DefaultScreen()
            // ? MangeSubDevision()
            : LoginScreen(),
      ),
    );
  }
}
