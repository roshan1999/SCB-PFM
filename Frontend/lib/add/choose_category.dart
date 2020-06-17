
import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class categoryTemplate extends StatefulWidget {


  String label;
  IconData icon;
  categoryTemplate({this.label,this.icon});

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
                  // TO DO -- Add new category to user's category database table.
                  categories.removeLast(); // To show new category before the add category
                  categories.removeLast();
                  categories.add(categoryTemplate(icon: Icons.device_unknown, label: value));
                  categories.add(add_category); // To show others and add category option at the end of the grid
                  categories.add(others_category);
                });
              }
            });
          }
          else {
            Navigator.pop(context,widget.label);
          }
        },
        child: Card(
        color: Colors.green[50],
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Icon(widget.icon,
            color: Colors.lightGreen,size: 30.0,),
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
    categoryTemplate(label: 'Bills',icon: Icons.payment),
    categoryTemplate(label: 'Rent',icon: Icons.home),
    categoryTemplate(label: 'Food',icon: Icons.fastfood),
    categoryTemplate(label: 'Social Life',icon: Icons.local_bar),
    categoryTemplate(label: 'Entertainment',icon: Icons.music_note),
    categoryTemplate(label: 'Household',icon: Icons.local_grocery_store),
    categoryTemplate(label: 'Pharmacy',icon: Icons.healing),
    categoryTemplate(label: 'Transportation',icon: Icons.airport_shuttle),
    categoryTemplate(label: 'Personal Development',icon: Icons.person),
    others_category,
    add_category
    
  ];
// ignore: non_constant_identifier_names
categoryTemplate others_category = categoryTemplate(label: 'Others',icon: Icons.devices_other);
// ignore: non_constant_identifier_names
categoryTemplate add_category = categoryTemplate(label: 'Add',icon: Icons.add);


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
            onPressed: () {
              Navigator.pop(context, new_category.text.toString());
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
          children: categories.map((category)=>categoryTemplate(label: category.label,icon: category.icon,)).toList(),
        ),
      ),
      
    );
  }
}