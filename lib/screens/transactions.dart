import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:toast/toast.dart';
import 'package:crypto_app_ui/wrappers/ScannerWRapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  bool checkingMatic= true;
  String balanceMatic;
  List txList;
  bool fetching= true;
  String address;
  _getList() async {
    ScannerWrapper wrapper = new ScannerWrapper();
    var json = await wrapper.getTransactions();
    var ls = json["result"] as List;
    setState(() {
      txList = ls;
      fetching =false;
    });

  }
  _getMatic(){
    EthWrapper wrapper = new EthWrapper();
    return  wrapper.checkBalanceMatic();
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  var amount = new TextEditingController();
  var recipient = new TextEditingController();
  @override
  void initState() {
    _getList();
    _getMatic().then((matic){
      setState(() {
        balanceMatic=matic;
        checkingMatic=false;
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      //physics: ScrollPhysics(),
     // primary:  false,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Icon(Icons.refresh),
                onPressed: _refresh,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
            )
          ],
        ),
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
                  validator: (val) => val==""?null:(val.length==42?
                  null: "Invalid Input"),
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    Toast.show("Transacting", context,duration: Toast.LENGTH_LONG);
                    EthWrapper wrapper= new EthWrapper();
                    await wrapper.transferToken(recipient.text, double.parse(amount.text)).then((val){
                      if(val){
                        Toast.show("Succeful", context, duration: Toast.LENGTH_LONG);
                        _refresh();
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
     Text("Transaction history:", style: TextStyle(fontWeight: FontWeight.bold),),
     fetching?_loader(): Expanded(
       child: ListView.builder(
         itemCount: txList.length,
         itemBuilder: (context, pos){
           return Padding(
             padding: EdgeInsets.all(5),
             child: Card(
               elevation: 4,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(
                   Radius.circular(10),
                 ),
               ),
               child: Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Column(
                   children: <Widget>[
                     Text("From:", style: TextStyle(fontWeight: FontWeight.bold),),
                     FlatButton(
                         child: Text(txList[pos]["from"]),
                       onPressed: (){
                          ClipboardManager.copyToClipBoard(txList[pos]["from"]);
                          Toast.show("Address copied",context,duration:Toast.LENGTH_LONG);
                       },

                     ),
                     SizedBox(height: 5,),
                     Text("To:", style: TextStyle(fontWeight: FontWeight.bold),),
                     FlatButton(
                       child: Text(txList[pos]["to"]),
                       onPressed: (){
                         ClipboardManager.copyToClipBoard(txList[pos]["to"]);
                         Toast.show("Address copied",context,duration:Toast.LENGTH_LONG);
                       },

                     ),
                     SizedBox(height: 5,),
                     Text("value:", style: TextStyle(fontWeight: FontWeight.bold),),
                     Text((int.parse(txList[pos]["value"])/1000000000000000000).toString()+"ETH"),

                   ],
                 ),
               ),
             ),
           );
         },

       ),
     )
      ],
    );
  }
  _refresh(){
    setState(() {
      checkingMatic= true;
      fetching =true;
    });

    _getMatic().then((matic){
      setState(() {
        balanceMatic=matic;
        checkingMatic=false;
      });

    });
    _getList();
  }
  _loader(){
    return SpinKitChasingDots(size: 30,color: Colors.indigo,);
  }
}
