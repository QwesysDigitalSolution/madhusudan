import 'package:flutter/material.dart';

const String api_url = "";
const inr_rupee = "₹";

class session {
  static const String session_login = "login_data";
  static const String user_name = "user_name";
}

Map<int, Color> app_primary_colors = {
  50: Color.fromRGBO(56, 48, 95, .1),
  100: Color.fromRGBO(56, 48, 95, .2),
  200: Color.fromRGBO(56, 48, 95, .3),
  300: Color.fromRGBO(56, 48, 95, .4),
  400: Color.fromRGBO(56, 48, 95, .5),
  500: Color.fromRGBO(56, 48, 95, .6),
  600: Color.fromRGBO(56, 48, 95, .7),
  700: Color.fromRGBO(56, 48, 95, .8),
  800: Color.fromRGBO(56, 48, 95, .9),
  900: Color.fromRGBO(56, 48, 95, 1)
};

MaterialColor app_primary_material_color =
    MaterialColor(0xFF9D0202, app_primary_colors);
