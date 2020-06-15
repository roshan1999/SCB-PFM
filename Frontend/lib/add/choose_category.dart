import 'package:flutter/material.dart';

class ExpenseCategories{
  String label;
  IconData icon;
  ExpenseCategories({this.label,this.icon});
}
class AddExpenseCategory extends StatefulWidget {

  @override
  _AddExpenseCategoryState createState() => _AddExpenseCategoryState();
}

class _AddExpenseCategoryState extends State<AddExpenseCategory> {
  List<ExpenseCategories> categories = [
    ExpenseCategories(label: 'Bills',icon: Icons.payment),
    ExpenseCategories(label: 'Rent',icon: Icons.home),
    ExpenseCategories(label: 'Food',icon: Icons.fastfood),
    ExpenseCategories(label: 'Social Life',icon: Icons.local_bar),
    ExpenseCategories(label: 'Entertainment',icon: Icons.music_note),
    ExpenseCategories(label: 'Household',icon: Icons.local_grocery_store),
    ExpenseCategories(label: 'Pharmacy',icon: Icons.healing),
    ExpenseCategories(label: 'Transportation',icon: Icons.airport_shuttle),
    ExpenseCategories(label: 'Personal Development',icon: Icons.person),
    ExpenseCategories(label: 'Others',icon: Icons.devices_other),
    ExpenseCategories(label: 'Add',icon: Icons.add),
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
