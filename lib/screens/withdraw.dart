import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foreground_service/foreground_service.dart';
class Withdraw extends StatefulWidget{
  @override
  WithdrawUi createState()=> new WithdrawUi();
}
class WithdrawUi extends State<Withdraw>{
  static const platform = const MethodChannel('WithdrawFunds');
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
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _startWithdraw();
          }
        ),
        SizedBox(height: 10),
      ],
    );
  }
  _fgserivce(){
    ForegroundService.startForegroundService(_sleep());
  }
  _sleep(){
    EthWrapper wrapper = new EthWrapper();
    var hash=wrapper.withdrawErc20(20.0);
    print(hash);
  }
  Future<void> _startWithdraw() async {
    await SharedPreferences.getInstance().then((prefs)async {
      var privateKey= prefs.getString("privateKey");
      try {
        final int result = await platform.invokeMethod('startWithdraw',{"privateKey":privateKey, "value":1});
        Toast.show("starting service"+result.toString(), context);
        print("Startig service:"+result.toString());
      } on PlatformException catch (e) {
        print("Faild to start service:"+ e.message.toString());
        Toast.show("Failed to start service", context);
      }
    });

  }


}