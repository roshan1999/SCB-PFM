import 'dart:convert';
import 'package:final_project/login_register/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

  // ignore: non_constant_identifier_names
  List Data = [];
  List<Category> myExpenseCategories = [];
  List<Category> myIncomeCategories = [];
  List<Transaction> myTransactions = [];

  Future<void> getTransactionData() async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    List data = [];
    String uri = Uri.encodeFull(url + "/transaction");
    String token = prefs.getString('token');
    print(uri);
    var response = await http.get(Uri.encodeFull(url + "/transaction"),
        headers: {
          'Content-type': 'application/json',
          'Accept': '*/*',
          'x-access-token': token
        });
    debugPrint("abc");
    print(Uri.encodeFull(url + "/transaction"));
    print(response.body);
//    if(json.decode(response.body)["message"] == "Token is invalid!") {
//      print("Error Invalid");
//      prefs.setString('token',null);
//      print("here noe");
//    }
        data = json.decode(response.body);
        var today = DateTime.now();
        var first_date =
        DateTime(today.year, today.month, 1).subtract(Duration(days: 1));
        var last_date =
        DateTime(today.year, today.month + 1, 0).add(Duration(days: 1));
        for (int i = 0; i < data.length; i++) {
          var recvdDate = DateFormat("dd-MM-yyyy").parse(
            data[i]["date"],
          );
          print(data[i]);
          print(first_date.toString() + last_date.toString());
          if (recvdDate.isAfter(first_date) && recvdDate.isBefore(last_date)) {
            print("HELLO = " + data[i].toString());
            myTransactions.add(Transaction(
                label: data[i]["label"],
                amount: data[i]["amount"].toString(),
                date: data[i]["date"].toString(),
                description: data[i]["description"]));
          }
        }
        kTransactions = myTransactions;
      }

  Future getCategory() async {
    final prefs = await SharedPreferences.getInstance();
    String url = prefs.getString('url');
    String month = DateFormat("dd-MM-yyyy").format(DateTime.now());
    String uri = Uri.encodeFull(url + "/category/" + month);
    String token = prefs.getString('token');
    print(uri);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token,
    };
    var response = await http.get(uri, headers: headers);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      this.setState(() {
        Data = json.decode(response.body);
        print(Data);
        print("HERE");
        isLoading = false;

        for (int i = 0; i < Data.length; i++) {
          if (Data[i]["amount"] != 0) if (Data[i]["cat_type"] == true) {
            myExpenseCategories.add(Category(Data[i]["label"],
                amount: double.parse(Data[i]["amount"].toString())));
          } else {
            myIncomeCategories.add(Category(Data[i]["label"],
                amount: double.parse(Data[i]["amount"].toString())));
          }
        }
        kCategories = myExpenseCategories;
        kIncomeCategories = myIncomeCategories;
      });
    });
  }

  @override
  void initState() {
    isLoading = true;
    this.getCategory();
      this.getTransactionData();
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var category in kCategories)
                  if (category.amount != 0)
                    ExpenseCategory(
                        text: category.name,
                        index: kCategories.indexOf(category)),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator());
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
      padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
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
          Flexible(child: Text(text.capitalize())),
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
