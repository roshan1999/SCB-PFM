import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class MyReminderPage extends StatefulWidget {
  final String dateText;
  final int amountText;
  final String descriptionText;
  final String enabled;
  final String id;
  MyReminderPage({Key key, this.title, this.id, this.dateText, this.amountText, this.descriptionText, this.enabled}) : super(key: key);
  final String title;

  @override
  _MyReminderPageState createState() {
    return _MyReminderPageState();
  }
}

class _MyReminderPageState extends State<MyReminderPage> {

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  DateTime date;
  DateTime _selectedDate = DateTime.now();
  var dateFormat = DateFormat('d-MM-yyyy');

  RegExp rgxDouble = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
  String currency = 'R',
      finDate = "";

  List<String> currDrop = ['R', 'Y', 'U', 'E'];
  List<Widget> test = [];
  List<String> itemList = ['Weekly', 'Monthly', 'Yearly'];


  TextEditingController _date ;
  TextEditingController _amount ;
  TextEditingController _description ;
  TextEditingController _frequency;
  TextEditingController _repeat_gap;
  @override
  void initState() {
    _description = TextEditingController();
    _date = TextEditingController();
    _amount = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _description.text = widget.descriptionText;
    _date.text = widget.dateText;
    _amount.text = widget.amountText==null?"":widget.amountText.toString();
    super.didChangeDependencies();
  }

  String url;
  String token;
  Future<http.Response> addReminder(String amount, String date, String description) async {
    final prefs = await SharedPreferences.getInstance();
    url = prefs.getString('url');
    String uri = Uri.encodeFull(url+"/reminder");
    token = prefs.getString('token');
    var bodyEncoded = json.encode({
      "due_date": date,
      "description": description,
      "amount": amount,
      "achieved":0});
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-access-token':token
    };
    var response;
    if(widget.enabled=="true"){
      print("Patch Update");
      uri = Uri.encodeFull(url + "/reminder");
      bodyEncoded = json.encode({
        "id":widget.id,
        "due_date": date,
        "description": description,
        "amount": amount
      });
      response = await http.patch(uri,headers:headers, body:bodyEncoded);
    }
    else{
      response = await http.post(uri, headers: headers, body: bodyEncoded);
    }
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

  void addDynamic() {
    setState(() {
      if (_isChecked == true) {
        test.removeLast();
        test.add(SizedBox(height:0.0));
        test.add(buildForm(Icons.account_balance_wallet, "Number of Transactions to repeat", _frequency,context));
        test.add(SizedBox(height:20.0));
        test.add(buildDropList("Frequency", itemList, "Monthly", _repeat_gap,context, fntSz: 18));
        test.add(SizedBox(height:20.0));
        test.add(buildButtonBar());
      } else {
        test.removeLast();
        test.removeLast();
        test.removeLast();
        test.removeLast();
        test.removeLast();
        test.removeLast();
        test.add(buildButtonBar());
      }
    });
  }

  List<Widget> _createChildren() {
    test = <Widget>[
      SizedBox(height: 40),
      buildHeader(),
      SizedBox(height: 30),
      buildDropList("Enter Amount", currDrop, currency, _amount,context),
      buildForm(Icons.note_add,"Enter Description", _description,context),
      buildDueDate(context),
      SizedBox(height: 20.0),
      buildCheckBox(context),
      buildButtonBar(),
    ];

    return test;
  }

  Padding buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
      child: Text(
        "REMINDER",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

  Row buildDropList(hintTxt,itemLst,currValue, _amount,BuildContext context, {double fntSz=24}) {
    return Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(28, 0, 10, 0),
            child: buildDropdownButton(itemLst,currValue,fntSz)),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 18.0, 0),
              child: TextFormField(
                controller: _amount,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: "Enter Amount",
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
  StatefulBuilder buildDropdownButton(List<String> lst, currValue,fntSz) {
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

  Padding buildForm(icon, hintTxt, _description,BuildContext context){
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

  StatefulBuilder buildCheckBox(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: CheckboxListTile(
              title: Text("Repeat Transaction",
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              value: _isChecked,
              onChanged: (bool value) {
                setState(() {
                  debugPrint("Checked");
                  _isChecked = value;
                  addDynamic();
                });
              },
            ),
          );
        });
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
            Navigator.pop(context);
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
            addReminder(_amount.text, _date.text, _description.text).then((response){
            if(response.statusCode==200){
              print("Success");
            }
            });
            Fluttertoast.showToast(
                msg: "Success",
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white,
                fontSize: 16.0
            );
            Navigator.of(context).pop();
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

  FlatButton buildSubmit() {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text("Submit",
          style: TextStyle(fontSize: 24, color: Colors.indigo),
          textAlign: TextAlign.right),
      onPressed: () {
        Navigator.of(context).pop();
        addDynamic();
      },
    );
  }

}