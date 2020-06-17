
import 'package:final_project/login_register/initialize_categories.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class categoryTemplate extends StatefulWidget {


  String label;
  IconData icon;
  Color card_color;
  categoryTemplate({this.label,this.icon,this.card_color});

  @override
  _categoryTemplateState createState() => _categoryTemplateState();
}

class _categoryTemplateState extends State<categoryTemplate> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          if (widget.label == "Add") {
            showDialog(context: context, builder:(context)=>createCategoryDialog(context)).then((value) {
              if (value == null || value.length == 0 || value == "Discard") {
                print(value);
              }
              else {
                setState(() {
                  print("called");
                });
              }
            });
          }
          else {
            Navigator.pop(context,widget.label);
          }
        },
        child: Card(
        color: widget.card_color,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Icon(widget.icon,
            color: Colors.blueAccent,size: 30.0,),
            SizedBox(height:8.0,),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14.0,
              ),
            )
          ],
        ),
    ),

    );
  }


}
List<categoryTemplate> categories = [
    categoryTemplate(label:'Salary',icon: Icons.attach_money,card_color: Colors.blue[50]),
    categoryTemplate(label:'Rental',icon: Icons.money_off, card_color: Colors.blue[50]),
    categoryTemplate(label:'Other income',icon: Icons.devices_other,card_color: Colors.blue[50]),
    categoryTemplate(label: 'Bills',icon: Icons.payment,card_color: Colors.redAccent[50]),
    categoryTemplate(label: 'Rent',icon: Icons.home, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Food',icon: Icons.fastfood, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Social Life',icon: Icons.local_bar, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Entertainment',icon: Icons.music_note, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Household',icon: Icons.local_grocery_store, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Pharmacy',icon: Icons.healing, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Transportation',icon: Icons.airport_shuttle, card_color:Colors.redAccent[50]),
    categoryTemplate(label: 'Personal Development',icon: Icons.person, card_color:Colors.redAccent[50]),
    others_category,
    add_category
    
  ];
// ignore: non_constant_identifier_names
categoryTemplate others_category = categoryTemplate(label: 'Others',icon: Icons.devices_other, card_color:Colors.green[50]);
// ignore: non_constant_identifier_names
categoryTemplate add_category = categoryTemplate(label: 'Add',icon: Icons.add, card_color:Colors.green[50]);


// ignore: non_constant_identifier_names
TextEditingController new_category = TextEditingController();

class pageCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Widget createCategoryDialog(BuildContext context){
//    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Add New Category'),
        content: TextField(
          decoration: (InputDecoration(
            hintText: 'Enter name of category',
          )),
          controller: new_category,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Add Category'),
            onPressed: () async {
              if(new_category==null || new_category.toString()==''){
                Navigator.pop(context);
              }
              else{
                // Added the new category to database
              addCategory('0', new_category.text, '01-06-2020', true);
              addCategory('0', new_category.text, '01-07-2020', true);
              addCategory('0', new_category.text, '01-08-2020', true);

              categories.removeLast(); // To show new category before the add category
              categories.removeLast();
              categories.add(categoryTemplate(card_color: Colors.green[50], icon: Icons.device_unknown, label: new_category.text.toString()));
              categories.add(others_category); // To show others and add category option at the end of the grid
              categories.add(add_category);
              await Navigator.push(context,MaterialPageRoute(builder: (context) =>  ChooseCategoryPage()));
              }
            }
          ),
          MaterialButton(
              elevation: 5.0,
              child: Text('Cancel'),
              onPressed: (){
                Navigator.pop(context,"Discard");
              }
          ),
        ],
      );
//    },
//    );
  }

class ChooseCategoryPage extends StatelessWidget {
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
          children: categories.map((category)=>categoryTemplate(label: category.label,icon: category.icon,card_color: category.card_color,)).toList(),
        ),
      ),
      
    );
  }
}