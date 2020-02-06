import 'dart:async';
import 'package:dio/dio.dart';
import 'package:madhusudan/common/ClassList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:madhusudan/common/Constants.dart' as cnst;

Dio dio = new Dio();

class Services{
  static Future<List> GetServiceForList(String APIName, List params) async {
    String Url = "";
    if (params.length > 0) {
      Url = APIName + "?";
      for (int i = 0; i < params.length; i++) {
        Url = Url + '${params[i]["key"]}=${params[i]["value"]}';
        if (i + 1 != params.length) Url = Url + "&";
      }
    } else
      Url = APIName;

    String url = cnst.api_url + '$Url';
    print("$APIName URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("$APIName Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("$APIName Erorr : " + e.toString());
      throw Exception(e);
    }
  }

}