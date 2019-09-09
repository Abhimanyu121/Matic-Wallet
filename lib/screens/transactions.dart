import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:toast/toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  bool checkingMatic= true;
  String balanceMatic;
  _getMatic(){
    EthWrapper wrapper = new EthWrapper();
    return  wrapper.checkBalanceMatic();
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  var amount = new TextEditingController();
  var recipient = new TextEditingController();
  @override
  void initState() {
    _getMatic().then((matic){
      setState(() {
        balanceMatic=matic;
        checkingMatic=false;
      });

    });
  }
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
                child: checkingMatic? _loader():Text(balanceMatic.toString()+" DAI", style: TextStyle(fontSize: 30),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: recipient,
                  autovalidate: true,
                  obscureText: false,
                  validator: (val) => val.length==42?
                  null: "Invalid Input",
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
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: amount,
                  autovalidate: true,
                  validator: (val) => val==""?null:(double.parse(val)<=0?
                  "Invalid amount":
                  null),
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
                  onPressed: ()async {
                    EthWrapper wrapper= new EthWrapper();
                    await wrapper.transferToken(recipient.text, double.parse(amount.text)).then((val){
                      if(val){
                        Toast.show("Succeful", context, duration: Toast.LENGTH_LONG);
                      }
                      else{
                        Toast.show("Something went Wrong",context,duration: Toast.LENGTH_LONG);
                      }
                    });
                  },
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
  _loader(){
    return SpinKitChasingDots(size: 30,color: Colors.indigo,);
  }
}
