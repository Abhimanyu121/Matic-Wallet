import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_app_ui/wrappers/moonPayWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
class Wallets extends StatefulWidget {
  @override
  _WalletsState createState() => new _WalletsState();
}

class _WalletsState extends State<Wallets> {
  String balanceRopsten="123";
  String balanceMatic= "Asd";
  String txApprove="";
  String txAllow="";
  String txDeposit="";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  bool checking =true;
  bool eth =false;
  var _amount = new TextEditingController();
  bool checkingMatic= true;
  bool transfering =false;
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
      setState(() {
        balanceMatic=matic;
        checkingMatic=false;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          _refresh().then((){
            _refreshIndicatorKey.currentState.dispose();
          });
        },
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: _refresh,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                ),
                RaisedButton(
                    child: Text("Approve all"),
                    onPressed: _approveAll,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                )
              ],
            ),
          txApprove==""||txApprove==null?SizedBox(height: 1,):Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(txApprove,style: TextStyle(fontSize: 10),),
                FlatButton(
                  onPressed: (){
                    ClipboardManager.copyToClipBoard(txApprove).then((asd){
                      Toast.show("Hash copied", context);
                    });
                  },
                  child: Icon(Icons.content_copy),
                )
              ],
            ),
            txAllow==""||txAllow==null?SizedBox(height: 1,):Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(txApprove,style: TextStyle(fontSize: 10),),
                FlatButton(
                  onPressed: (){
                    ClipboardManager.copyToClipBoard(txAllow).then((asd){
                      Toast.show("Hash copied", context);
                    });
                  },
                  child: Icon(Icons.content_copy),
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
              child: transfering?_transfering():Column(
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
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("* You need to approve all before being able to deposit to matic", style: TextStyle(fontSize: 12,color: Colors.red),),
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
                          hintText: "DAIs to Send",
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
                    onPressed: ()async{
                      FocusScope.of(context).requestFocus(FocusNode());
                      EthWrapper wrapper = new EthWrapper();
                      await wrapper.checkEth().then((val){
                        BigInt wei = val;
                        if(wei<BigInt.from(1000000000000000)){
                          _asyncConfirmDialog(context);
                        }
                        else{
                          _deposit();
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            txDeposit==""||txDeposit==null?SizedBox(height: 1,):Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(txApprove,style: TextStyle(fontSize: 10),),
                FlatButton(
                  onPressed: (){
                    ClipboardManager.copyToClipBoard(txApprove).then((asd){
                      Toast.show("Hash copied", context);
                    });
                  },
                  child: Icon(Icons.content_copy),
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
  _transfering(){
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 100,),
        Text("Transferring tokens"),
        SpinKitChasingDots(size: 30,color: Colors.blueAccent,),
        SizedBox(height: 100,),

      ],
    );
  }
  _deposit()async {
    Toast.show("Processing!", context,duration: Toast.LENGTH_LONG);
    setState(() {
      transfering= true;
    });

    EthWrapper wrapper = new EthWrapper();
    await wrapper.depositERC20(double.parse(_amount.text)).then((val){
      print("wallet:" +val);
      setState(() {
        txDeposit=val;
      });
    });
    setState(() {
      transfering =false;
    });
  }
  Future<bool> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insufficient Eth'),
          content: eth?_loader(): Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  'You have insufficient funds for trnasfer of token, would you like to buy some(20 USD) ether?'),
              Text("* Try after 2 minutes of depositing ether", style: TextStyle(color: Colors.red),)
            ],
          ),

          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: const Text('Deposit'),
              onPressed: () async {
                setState(() {
                  eth =true;
                });
                Toast.show("In proccess, please wait for 2 minutes", context,duration: Toast.LENGTH_LONG);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String jwt = prefs.getString("jwt");
                String address= prefs.getString("address");
                MoonPayWrapper wrapper = new MoonPayWrapper();
                List ls = await wrapper.getCardList(jwt);
                await wrapper.addEth(jwt, address, ls[0]["id"]).then((val){
                  setState(() {
                    eth =false;
                  });
                  Navigator.of(context).pop(true);
                });

              },
            )
          ],
        );
      },
    );
  }
  _approveAll()async {
    EthWrapper wrapper = new EthWrapper();
    await wrapper.checkEth().then((val)async{
      BigInt wei = val;
      if(wei<BigInt.from(1500000000000000)){
        _asyncConfirmDialog(context);
      }
      else{
        EthWrapper wrapper = new EthWrapper();
        var txall= await wrapper.allowanceToken();
        var txappr = await wrapper.approveToken(double.parse(balanceRopsten));
        Toast.show("In Proccess, wait for 2 minutes", context,duration: Toast.LENGTH_LONG);
        setState(() {
          txAllow=txall;
          txApprove= txappr;
        });
      }
    });
  }
  _refresh()async {
    setState(() {
      checkingMatic= true;
      checking =true;
    });
     _getBalance().then((str){
      setState(() {
        //print("amount :"+str);
        balanceRopsten =str;
        checking = false;
      });
    });
     _getBalanceMatic().then((matic){
       setState(() {
         checkingMatic=false;
         balanceMatic=matic;
       });
     });
  }
}

