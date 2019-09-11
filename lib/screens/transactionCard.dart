import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/ScannerModel.dart';
import 'dart:convert';
class widgetTransaction extends StatefulWidget{
  Map sc;
  widgetTransaction(Map val){
    this.sc= val;
  }

  @override
  widgetTransactionUi createState() => new widgetTransactionUi();
}
class widgetTransactionUi extends State<widgetTransaction>{
  Map sc;
  widgetTransaction(Map val){
    //print("bleh: "+sc.toString());
    this.sc= val;
  }
  @override
  Widget build(BuildContext context) {
    print("wait"+sc.toString());
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
          Text("Transaction Hash:", style: TextStyle(fontWeight: FontWeight.bold),),
         Text(sc["hash"]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("From: "+sc["from"]),
              Text("To: "+sc["to"]),
              Text("Error: "+(sc["isError"]==0?"No error":"Error")),
            ],
          ),
          Text("Result: "+sc["nonce"] ),
        ],
      ),
    );
  }

}
