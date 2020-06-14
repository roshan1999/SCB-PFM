import 'package:flutter/material.dart';

class ExpenseCategories{
  String label;
  IconData icon
  ExpenseCategories({this.label,this.icon});
}
class AddExpenseCategory extends StatefulWidget {

  @override
  _AddExpenseCategoryState createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  List<ExpenseCategories> categories = [
    ExpenseCategories(label: 'Bills',icon: 'payment'),
    ExpenseCategories(label: 'Rent',icon: 'home'),
    ExpenseCategories(label: 'Food',icon: 'fastfood'),
    ExpenseCategories(label: 'Social Life',icon: 'local_bar'),
    ExpenseCategories(label: 'Entertainment',icon: 'music_note'),
    ExpenseCategories(label: 'Household',icon: 'local_grocery_store'),
    ExpenseCategories(label: 'Pharmacy',icon: 'healing'),
    ExpenseCategories(label: 'Transportation',icon: 'airport_shuttle'),
    ExpenseCategories(label: 'Personal Development',icon: 'person'),
    ExpenseCategories(label: 'Others',icon: 'devices_others'),
    ExpenseCategories(label: 'Add',icon: 'add'),
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
            Icon(category.icon,
            color: Colors.lightGreen,size: 30.0,),
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
