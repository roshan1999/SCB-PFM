import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import './PieChart.dart';

class CategoriesRow extends StatefulWidget {
  const CategoriesRow({
    Key key,
  }) : super(key: key);

  @override
  _CategoriesRowState createState() => _CategoriesRowState();
}

class _CategoriesRowState extends State<CategoriesRow> {
  var isLoading;
  List Data = [];
  List<Category> myCategories= [];
  Future getCategory() async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String uri = Uri.encodeFull(url + "/category");
    String token = prefs.getString('token');
    print(uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token,
    };
    var response = await http.get(uri, headers: headers);
    this.setState(() {
      Data = json.decode(response.body);
      print(Data);
      print("HERE");
      isLoading = false;
      double amount;

      for(int i =0;i<Data.length;i++){
        if(Data[i]["cat_type"]==true)
          myCategories.add(Category(Data[i]["label"], amount: double.parse(Data[i]["amount"].toString())));
      }
      kCategories = myCategories;
    });
  }
  @override
  void initState(){
    isLoading = true;
    this.getCategory();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return !isLoading?Expanded(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (var category in kCategories)
            if(category.amount!=0)
              ExpenseCategory(text: category.name, index: kCategories.indexOf(category)),
        ],
      ),
    ):
        CircularProgressIndicator();
  }
}

class ExpenseCategory extends StatelessWidget {
  const ExpenseCategory({
    Key key,
    @required this.index,
    @required this.text,
  }) : super(key: key);

  final int index;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
              kNeumorphicColors.elementAt(index % kNeumorphicColors.length),
            ),
          ),
          SizedBox(width: 20),
          Text(text.capitalize()),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}