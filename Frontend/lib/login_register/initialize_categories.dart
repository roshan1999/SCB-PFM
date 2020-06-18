import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String url,token;
Future<http.Response> addCategory(String amount, String label, String month, bool cat_type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    String uri = Uri.encodeFull(url + "/category");

    var bodyEncoded = json.encode({
      "month": month,
      "cat_type": cat_type,
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

 void initialize_categories(){
   addCategory('0','Salary','01-06-2020',false);
   addCategory('0','Rental','01-06-2020', false);
   addCategory('0', 'Other Income', '01-06-2020',false);
   addCategory('0', 'Bills', '01-06-2020', true);
   addCategory('0', 'Rent', '01-06-2020', true);
   addCategory('0', 'Food', '01-06-2020', true);
   addCategory('0', 'Social Life', '01-06-2020', true);
   addCategory('0', 'Entertainment', '01-06-2020', true);
   addCategory('0', 'Household', '01-06-2020', true);
   addCategory('0', 'Pharmacy', '01-06-2020', true);
   addCategory('0', 'Transportation','01-06-2020',true);
   addCategory('0', 'Personal Development', '01-06-2020', true);
   addCategory('0', 'Others', '01-06-2020', true);

   addCategory('0','Salary','01-07-2020',false);
   addCategory('0','Rental','01-07-2020', false);
   addCategory('0', 'Other Income', '01-07-2020',false);
   addCategory('0', 'Bills', '01-07-2020', true);
   addCategory('0', 'Rent', '01-07-2020', true);
   addCategory('0', 'Food', '01-07-2020', true);
   addCategory('0', 'Social Life', '01-07-2020', true);
   addCategory('0', 'Entertainment', '01-07-2020', true);
   addCategory('0', 'Household', '01-07-2020', true);
   addCategory('0', 'Pharmacy', '01-07-2020', true);
   addCategory('0', 'Transportation','01-07-2020',true);
   addCategory('0', 'Personal Development', '01-07-2020', true);
   addCategory('0', 'Others', '01-07-2020', true);

   addCategory('0','Salary','01-08-2020',false);
   addCategory('0','Rental','01-08-2020', false);
   addCategory('0', 'Other Income', '01-08-2020',false);
   addCategory('0', 'Bills', '01-08-2020', true);
   addCategory('0', 'Rent', '01-08-2020', true);
   addCategory('0', 'Food', '01-08-2020', true);
   addCategory('0', 'Social Life', '01-08-2020', true);
   addCategory('0', 'Entertainment', '01-08-2020', true);
   addCategory('0', 'Household', '01-08-2020', true);
   addCategory('0', 'Pharmacy', '01-08-2020', true);
   addCategory('0', 'Transportation','01-08-2020',true);
   addCategory('0', 'Personal Development', '01-08-2020', true);
   addCategory('0', 'Others', '01-08-2020', true);
 }
 