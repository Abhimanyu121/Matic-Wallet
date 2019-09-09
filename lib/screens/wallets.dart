import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Wallets extends StatefulWidget {
  @override
  _WalletsState createState() => new _WalletsState();
}

class _WalletsState extends State<Wallets> {
  String balanceRopsten="123";
  String balanceMatic= "Asd";
  bool checking =true;
  bool checkingMatic= true;
  _loader(){
    return SpinKitChasingDots(size: 30,color: Colors.indigo,);
  }
   _getBalance()async {
    EthWrapper wrapper = new EthWrapper();
     return  wrapper.checkBalanceRopsten();

  }
  _getBalanceMatic(){
    EthWrapper wrapper = new EthWrapper();
    return  wrapper.checkBalanceMatic();
  }
  @override
  void initState() {
    _getBalance().then((str){
      setState(() {
        //print("amount :"+str);
        balanceRopsten =str;
        checking = false;
      });
    });
    _getBalanceMatic().then((matic){
      balanceMatic=matic;
      checkingMatic=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: (){
          _refresh();
        },
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
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
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/eth.png",
                              height: 30,
                              width: 25,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Ropsten",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),

                          ],
                        ),
                        checking? _loader():Text((double.parse(balanceRopsten)*70).toStringAsFixed(2)+" INR"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      child: checking? _loader():Text(balanceRopsten.toString()+" DAI", style: TextStyle(fontSize: 30),),
                    ),
                  ),

                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(200),
                    ),
                    color: Colors.blueAccent,
                    child: Text("Transfer to matic"),
                    onPressed: (){},
                  ),
                  SizedBox(height: 10),
                ],
              ),
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
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/matic.png",
                              height: 30,
                              width: 25,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Matic",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),

                          ],
                        ),
                        checkingMatic? _loader():Text((double.parse(balanceMatic)*70).toString()+" INR"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      child: checkingMatic?  _loader():Text(balanceMatic.toString()+" DAI", style: TextStyle(fontSize: 30),),
                    ),
                  ),

                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(200),
                    ),
                    color: Colors.blueAccent,
                    child: Text("Transfer to Ropsten"),
                    onPressed: (){},
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  _refresh(){
    _getBalance().then((str){
      setState(() {
        //print("amount :"+str);
        balanceRopsten =str;
        checking = false;
      });
    });
    _getBalanceMatic().then((matic){
      balanceMatic=matic;
      checkingMatic=false;
    });
  }
}

