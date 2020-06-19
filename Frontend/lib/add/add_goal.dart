import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyGoalPage extends StatefulWidget {
  final String title;
  final String dateText;
  final int amountText;
  final int amountSaveText;
  final String descriptionText;
  final String enabled;
  final String id;
  MyGoalPage({Key key, this.title, this.id, this.dateText, this.amountText, this.amountSaveText, this.descriptionText, this.enabled}):super(key:key);
  @override
  _MyGoalPageState createState() {
    return _MyGoalPageState();
  }
}

class _MyGoalPageState extends State<MyGoalPage> {
  _MyGoalPageState();
  String title = "Goal";
  final _formKey = GlobalKey<FormState>();
  DateTime date;
  DateTime _selectedDate = DateTime.now();
  var dateFormat = DateFormat('d-MM-yyyy');

  RegExp rgxDouble = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
  String currency = 'R', finDate = "";

  TextEditingController _date;
  TextEditingController _amountTotal;
  TextEditingController _amountSaved;
  TextEditingController _description;

  // ignore: non_constant_identifier_names

  List<String> currDrop = ['R', 'Y', 'U', 'E'];
  List<Widget> test = [];
  String url,token;


  @override
  void initState() {
    _description = TextEditingController();
    _date = TextEditingController();
    _amountSaved = TextEditingController();
    _amountTotal = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _description.text = widget.descriptionText;
    _date.text = widget.dateText;
    _amountTotal.text = widget.amountText==null?"":widget.amountText.toString();
    _amountSaved.text = widget.amountSaveText==null?"":widget.amountSaveText.toString();
    super.didChangeDependencies();
  }

  Future<http.Response> addGoal(
      String amountTotal, String amountSave,String date, String description) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    token = prefs.getString('token');

    String uri = Uri.encodeFull(url + "/goal");

    var bodyEncoded = json.encode({
      "due_date": date,
      "description": description,
      "amount_total": amountTotal,
      "amount_saved": amountSave
    });
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': token
    };
    var response;
    if(widget.enabled=="true"){
      print("Patch Update");
      uri = Uri.encodeFull(url + "/goal");
      bodyEncoded = json.encode({
        "id":widget.id,
        "due_date": date,
        "description": description,
        "amount_total": amountTotal,
        "amount_saved": amountSave
      });
      response = await http.patch(uri,headers:headers, body:bodyEncoded);
    }
    else{
      response = await http.post(uri, headers: headers, body: bodyEncoded);
    }
    print(response.body);
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
//    print(dateText+amountText+amountSaveText+descriptionText);
    test = <Widget>[
      SizedBox(height: 40),
      buildHeader("Goal"),
      SizedBox(height: 30),
      buildDropList("Enter Amount", currDrop, currency, _amountTotal),
      buildForm(Icons.note_add, "Enter Description"),
      SizedBox(height: 30),
      buildDropList("Amount Saved Already", currDrop, currency, _amountSaved),
      buildDueDate(context),
      SizedBox(height: 40.0),
      buildButtonBar(),
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

  Padding buildForm(icon, hintTxt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 25, 18.0, 0),
      child: TextFormField(
        controller: _description,
        textAlign: TextAlign.center,
        autofocus: false,
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
                      hintText: "Enter Due Date",
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
            Navigator.of(context).pop();
            debugPrint("Discard Called");
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
            print(_amountTotal.text);
            addGoal(_amountTotal.text,_amountSaved.text, _date.text, _description.text)
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
}
