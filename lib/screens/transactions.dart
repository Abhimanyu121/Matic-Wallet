import 'package:flutter/material.dart';


class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("123 DAI", style: TextStyle(fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                      hintText: "Recipient Address",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                      hintText: "DAIs to Send",
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
        ),
      ],
    );
  }
}
