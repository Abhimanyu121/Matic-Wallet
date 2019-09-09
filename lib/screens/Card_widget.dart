import 'package:flutter/material.dart';
class CardWidget extends StatelessWidget{
  String cardDigit;
  String year;
  CardTheme(String cardDigit, String year){
    this.cardDigit= cardDigit;
    this.year = year;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              obscureText: false,
              style: style,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                  hintText: "DAIs to Deposit",
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){},
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Transact', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

}