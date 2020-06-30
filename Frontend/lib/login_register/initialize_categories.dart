import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String url,token;
Future<http.Response> addCategory(String amount, String label, String month, bool catType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    String uri = Uri.encodeFull(url + "/category");

    var bodyEncoded = json.encode({
      "month": month,
      "cat_type": catType,
      "amount": amount,
      "label": label
    });
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token
    };
    var response = await http.patch(uri, headers: headers, body: bodyEncoded);
    return (response);
  }

 // ignore: non_constant_identifier_names
