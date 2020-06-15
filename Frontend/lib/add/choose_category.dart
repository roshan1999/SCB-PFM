import 'package:flutter/material.dart';

class ExpenseCategories{
  String label;
  String iconType;
  ExpenseCategories({this.label,this.iconType});
}
class AddExpenseCategory extends StatefulWidget {

  @override
  _AddExpenseCategoryState createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  List<ExpenseCategories> categories = [
    ExpenseCategories(label: 'Bills',iconType: "payment"),
    ExpenseCategories(label: 'Rent',iconType: 'home'),
    ExpenseCategories(label: 'Food',iconType: 'fastFood'),
    ExpenseCategories(label: 'Social Life',iconType: 'local_bar'),
    ExpenseCategories(label: 'Entertainment',iconType: 'music_note'),
    ExpenseCategories(label: 'Household',iconType: 'local_grocery_store'),
    ExpenseCategories(label: 'Pharmacy',iconType: 'healing'),
    ExpenseCategories(label: 'Transportation',iconType: 'airport_shuttle'),
    ExpenseCategories(label: 'Personal Development',iconType: 'person'),
    ExpenseCategories(label: 'Others',iconType: 'devices_others'),
    ExpenseCategories(label: 'Add',iconType: 'add'),
  ];

  Widget categoryTemplate(category){
      return InkWell(
        onTap: () {
          if (category.label == "Add") {

          }
          else {
            Navigator.pop(context,category.label);
          }
        },
        child: Card(
        color: Colors.green[50],
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
//            Icon(category.iconType,
//            color: Colors.lightGreen,size: 30.0,),
            SizedBox(height:8.0,),
            Text(
              '${category.label}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            )
          ],
        ),
    ),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Choose Expense Category',
          ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: categories.map((category)=>categoryTemplate(category)).toList(),

        ),
      ),
    );
  }
}
