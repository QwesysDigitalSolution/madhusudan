import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madhusudan/common/Constants.dart' as cnst;
import 'package:madhusudan/screens/Login.dart';
import 'package:madhusudan/screens/ProductList.dart';
import 'package:madhusudan/screens/Login.dart';

//screen list
import 'screens/Splash.dart';
import 'screens/Dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Madhusudan",
      initialRoute: '/',
      routes: {
        '/': (context) => splash(),
        '/login': (context) => Login(),
        '/ProductList': (context) => ProductList(),
        '/Dashboard': (context) => Dashboard(),
      },
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          body1: GoogleFonts.oswald(textStyle: textTheme.body1),
        ),
        primaryColor: cnst.app_primary_material_color,
        primarySwatch: cnst.app_primary_material_color,
      ),
    );
  }
}
