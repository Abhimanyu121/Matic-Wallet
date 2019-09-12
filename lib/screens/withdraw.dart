import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Withdraw extends StatefulWidget{
  @override
  WithdrawUi createState()=> new WithdrawUi();
}
class WithdrawUi extends State<Withdraw>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  TextEditingController _amount = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: _withdrawUi(),
    );
  }
  _withdrawUi(){
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        top: 70,
        right: 20
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Withdraw Either",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),

        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _amount,
            autovalidate: true,
            validator: (val) => val==""?null:(double.parse(val)<=0?
            "Invalid amount":
            null),
            obscureText: false,
            style: style,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                hintText: "Amount to withdraw",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          ),
        ),

        RaisedButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(200),
          ),
          color: Colors.blueAccent,
          child: Text("Transfer to matic"),
          onPressed: ()async {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        ),
        SizedBox(height: 10),
      ],
    );
  }

}