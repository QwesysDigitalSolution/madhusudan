import 'package:flutter/material.dart';

const String api_url = "";
const inr_rupee = "₹";
const String img_url = "";
class session {
  static const String session_login = "login_data";
  static const String user_name = "user_name";
}

Map<int, Color> app_primary_colors = {
  50: Color.fromRGBO(220, 0, 0, .1),
  100: Color.fromRGBO(220, 0, 0, .2),
  200: Color.fromRGBO(220, 0, 0, .3),
  300: Color.fromRGBO(220, 0, 0, .4),
  400: Color.fromRGBO(220, 0, 0, .5),
  500: Color.fromRGBO(220, 0, 0, .6),
  600: Color.fromRGBO(220, 0, 0, .7),
  700: Color.fromRGBO(220, 0, 0, .8),
  800: Color.fromRGBO(220, 0, 0, .9),
  900: Color.fromRGBO(220, 0, 0, 1)
};

MaterialColor app_primary_material_color =
    MaterialColor(0xFFDC0000, app_primary_colors);
