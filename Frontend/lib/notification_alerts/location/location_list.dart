import 'package:flutter/material.dart';

class LocationPlace{
  String name;
  // type of google place
  // time spent at the location
  // Icon Type
  String time;
  LocationPlace({this.name,this.time});
}

class DailyLocationPlaces extends StatefulWidget {
  @override
  _DailyLocationPlacesState createState() => _DailyLocationPlacesState();
}

class _DailyLocationPlacesState extends State<DailyLocationPlaces> {

  List<LocationPlace> locations = [
    LocationPlace(name: 'Pharmacy Store',time:'11:51AM'),
    LocationPlace(name: 'Central Perk',time:'3:12PM'),
    LocationPlace(name: 'Shaws Bar',time: '8:13PM'),
  ];

  Widget placeTemplate(place){
    return Card(
      
      color: Colors.green[100],
      child: Row(
        children: <Widget>[
          Icon(Icons.place,
          size: 30.0,
          color: Colors.blue,
          ),
          SizedBox(width: 20.0,),
          Column(children: <Widget>[
            Text('You went to ${place.name} at ${place.time}'),
            Container(
              padding: EdgeInsets.fromLTRB(130.0, 0, 0, 0),
              child: RaisedButton.icon(onPressed: (){

              }, 
              icon: Icon(Icons.add),
              color: Colors.green[50],
              label: Text('Add Transaction'),
              ),
            )
          ],)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your timeline for day'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: locations.map((place)=>placeTemplate(place)).toList(),
      ) ,
      
    );
  }
}