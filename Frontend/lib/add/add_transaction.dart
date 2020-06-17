import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import './choose_category.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyTransPage extends StatefulWidget {
  MyTransPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyTransPageState createState() {
    return _MyTransPageState();
  }
}

class _MyTransPageState extends State<MyTransPage> {
  String title = "Transaction";
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  DateTime _selectedDate = DateTime.now();
  var dateFormat = DateFormat('d-MM-yyyy');

  RegExp rgxDouble = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
  String currency = 'R', finDate = "";

  List<String> currDrop = ['R', 'Y', 'U', 'E'];
  List<Widget> test = [];
  List<String> itemList = ['Weekly', 'Monthly', 'Yearly'];

  TextEditingController _date = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _label = new TextEditingController();
  String url;
  String token;

  Future<http.Response> addTransaction(
      String amount,String date, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');
    String uri = Uri.encodeFull(url + "/transaction");

    var bodyEncoded = json.encode({
      "date": date,
      "description": description,
      "amount": amount,
      "label": _label.text
    });
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token
    };
    var response = await http.post(uri, headers: headers, body: bodyEncoded);
    return (response);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: test.length <= 0
            ? Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _createChildren()),
              )
            : ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: test.length,
                itemBuilder: (_, i) => test[i],
              ),
      ),
    );
  }

  List<Widget> _createChildren() {
    test = <Widget>[
      SizedBox(height: 40),
      buildHeader(title),
      SizedBox(height: 60),
      buildDropList("Enter Amount", currDrop, currency,_amount),
      buildForm(Icons.note_add, "Enter Description",_description),
      buildDueDate(context),
      enterCategory1(Icons.add),
      SizedBox(height: 30.0),
      Padding(
        padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
        child: buildButtonBar(),
      ),
    ];

    return test;
  }

  Padding buildHeader(head) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
      child: Text(
        head.toString().toUpperCase(),
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row buildDropList(hintTxt, itemLst, currValue, amount, {double fntSz = 24}) {
    return Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(28, 0, 10, 0),
            child: buildDropdownButton(itemLst, currValue, fntSz)),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 18.0, 0),
            child: TextFormField(
              controller: amount,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                  hintText: hintTxt,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                      ))),
              style: GoogleFonts.lato(fontSize: 18, color: Colors.blue),
              validator: (value) {
                if (value.length == 0) {
                  return 'Please Enter amount';
                } else if (!rgxDouble.hasMatch(value)) {
                  return "Enter a valid amount";
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  StatefulBuilder buildDropdownButton(List<String> lst, currValue, fntSz) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        child: DropdownButton<String>(
          value: currValue,
          isDense: false,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 16,
          style: TextStyle(
              fontSize: fntSz, color: Colors.blue, fontWeight: FontWeight.bold),
//      underline: Container(
//        height: 2,
//        color: Colors.indigo,
//      ),
          onChanged: (String newValue) {
            setState(() {
              currValue = newValue;
            });
          },
          items: lst.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      );
    });
  }

  Padding buildForm(icon, hintTxt,description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 25, 18.0, 0),
      child: TextFormField(
        controller: description,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            hintText: hintTxt,
            icon: Icon(
              icon,
              color: Colors.blue,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.amber,
                  style: BorderStyle.solid,
                ))),
        style: GoogleFonts.lato(fontSize: 18, color: Colors.blue),
        validator: (value) {
          if (value.length == 0) {
            return 'Please Enter a Valid Value';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      //we wait for the dialog to return
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (d != null) //if the user has selected a date
      setState(() {
        // we format the selected date and assign it to the state variable
        _selectedDate = d;
        finDate = dateFormat.format(_selectedDate);
        _date.value = TextEditingValue(text: finDate);
      });
  }

  Padding buildDueDate(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 25, 18.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                width: 373,
                child: TextFormField(
                  controller: _date,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Please Enter Date';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "Date of Transaction",
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Colors.amber,
                            style: BorderStyle.solid,
                          ))),
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonBar buildButtonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        OutlineButton(
          child: Text(
            "Discard",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            debugPrint("Discard Called");
            Navigator.of(context).pop();
          },
          textColor: Colors.blueAccent,
          splashColor: Colors.indigoAccent,
          borderSide: BorderSide(color: Colors.blueAccent),
          shape: StadiumBorder(),
          textTheme: ButtonTextTheme.primary,
          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        ),
        MaterialButton(
          child: Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          onPressed: () {
            print(_amount.text);
            addTransaction(_amount.text, _date.text, _description.text)
                .then((response) {
              if (response.statusCode == 200) {
                print("Success");
                Fluttertoast.showToast(
                    msg: "Success",
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pop(context);
              }
              else{
                print(response.body);
              }
            });
          },
          shape: StadiumBorder(),
          padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
          color: Colors.blueAccent,
          textColor: Colors.white,
          splashColor: Colors.indigoAccent,
          textTheme: ButtonTextTheme.primary,
          elevation: 8,
        ),
      ],
    );
  }
  Widget enterCategory1(icon) {
    return Builder(
      builder:(ctxt)=>
      GestureDetector(
        child: Container(
          color:Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 25, 18.0, 0),
            child: IgnorePointer(
              child: TextField(
                controller: _label,
                onChanged: (_label)=>{},
                readOnly: true,
                textAlign: TextAlign.center,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Enter Category',
                  icon: Icon(
                    icon,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                style: GoogleFonts.lato(fontSize: 18, color: Colors.blue),
              ),
            ),
          ),
        ),
        onTap: () {
          _navigateAndDisplay(ctxt);

        },
      ),
    );
  }

  _navigateAndDisplay(BuildContext context) async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  ChooseCategoryPage(),
      ),
    );
    _label.text = result;
  }
}
