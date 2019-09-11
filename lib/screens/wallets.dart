import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:crypto_app_ui/wrappers/moonPayWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:crypto_app_ui/wrappers/ScannerWRapper.dart';
class Wallets extends StatefulWidget {
  @override
  _WalletsState createState() => new _WalletsState();
}

class _WalletsState extends State<Wallets> {
  String balanceRopsten="123";
  String balanceMatic= "Asd";
  bool allowance =false;
  String txAllow="";
  bool approve= false;
  String txDeposit="";
  bool transacting =false;
  Map json={"result":{"status":"0"}};
  String hash=" ";
  int loading=0;
  bool checking =true;
  bool eth =false;
  bool err =false;
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
  _getApproveStatus()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    if(prefs.getBool("approve")==true)
      return true;
    else
      return false;
  }
  _getAllownceStatus()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    if(prefs.getBool("allow")==true)
      return true;
    else
      return false;
  }
  _getTransaction() async{
    await SharedPreferences.getInstance().then((prefs)async{
      String hash= prefs.getString("hash");

      bool transacting = prefs.getBool("transacting");
      if(transacting==true) {
        setState(() {
          transacting = true;
        });
      }else{
        setState(() {
          transacting= false;
        });
      }
       // print("chhas:"+hash);
        if(hash ==""||hash==null){
          Map mv ={"status":"0"};
          return mv;
        }else{
          print("here");
          ScannerWrapper wrapper = new ScannerWrapper();
          await  wrapper.getDetails(hash).then((jss){

            print("checking:"+jss.toString());
            setState(() {
              json =jss;
            });
            _check();
            return jss;
          });
        }



    });

  }
  _getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool transacting = prefs.getBool("transacting");
    if(transacting== true)
      return transacting;
    else
      return false;
  }
  _getBalanceMatic(){
    EthWrapper wrapper = new EthWrapper();
    return  wrapper.checkBalanceMatic();
  }
  _getHash()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hash = prefs.getString("hash");
    if(hash==null||hash=="")
      return "There are no Transactions";
    else
      setState(() {
        this.hash = hash;
      });
    return hash;
  }
_check()async{
  if(json["result"]["status"]=="1"||json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
     await SharedPreferences.getInstance().then((prefs){
       setState(() {
         transacting=false;
         print("check2:"+transacting.toString());
       });
       prefs.setBool("transacting", false);
     });

  }
  if(json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
    setState(() {
      transacting =false;
      err= true;
    });
    print("err: check"+err.toString());
  }
}

  @override
  void initState() {
    loading =0;
    _getApproveStatus().then((val){
      setState(() {
        loading++;
        approve =val;
      });

    });
    _getAllownceStatus().then((val){
      setState(() {
        loading++;
        allowance =val;
      });

    });
    _getHash().then((str){
      setState(() {
        loading++;
       // hash= str;
      });
    });
    _getStatus().then((val){
      setState(() {
        loading++;
        //transacting= val;
      });

    });
    _getTransaction().then((json){
      setState(() {
        loading++;
        //this.json= json;
        print("check1:"+json.toString());
        _check();
      });
    });
    _check();

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


    print("js: "+json.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
    //double c_width = MediaQuery.of(context).size.width*0.8;
    return Scaffold(
      body: ListView(
        shrinkWrap:true,
        physics: ScrollPhysics(),
        primary: false,
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: loading!=5?_loader():(transacting?Text("Refresh Transaction"):(approve?Text("Approve all"):(allowance?Text("Allow Contract"):((json["message"]=="NOTOK"||json["result"]["status"]=="0")?Text("Increase Allowance"):Text("Refresh"))))),
                  onPressed:(){
                    if(loading==5){
                      if((json["message"]=="NOTOK"||json["result"]["status"]=="0"))
                      {
                        _incAllow();
                        _refreshTx();
                      }
                      else if(transacting)
                      {
                        _refreshTx();
                      }
                      else if(approve){
                        _approveAll() ;
                        _refreshTx();
                      }
                      else if(allowance){
                        _allow();
                        _refreshTx();
                      }
                      else if(json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
                        _incAllow();
                        _refreshTx();
                      }
                      else{
                        _refreshTx();
                        Toast.show("Nothing to do right now",context);
                      }
                    }
                  } ,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loading!=5?_loader():Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40,),
                      (hash==""||hash==" ")?Text("There are no transactions"):Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          FlatButton(
                            child: Text(hash, maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                            onPressed: (){
                              ClipboardManager.copyToClipBoard(hash).then((val){
                                Toast.show("Hash Copied", context);
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      (hash==" "||hash=="")?
                        Container(height: 0,width: 0,)
                          :((json["message"]=="NOTOK"||json["result"]["status"]=="0")?Text("Transaction Ended with error")
                          :(json["result"]["status"]=="1"?Text("Transaction has been merged")
                          :Text("Transaction not merged yet"))),
                      //js==null?Container(height: 0,width: 0,):
                      SizedBox(
                        height: 10,
                      ),
                      (hash==" "||hash=="")?
                      Container(height: 0,width: 0,)
                          :((json["message"]=="NOTOK"||json["result"]["status"]=="0")?Icon(Icons.error)
                          :(json==null?Container(height: 0,width: 0,)
                          :(json["result"]["status"]=="1"?Icon(Icons.check , size: 30,)
                          :SpinKitChasingDots(color: Colors.blue,size: 30,)))),
                      SizedBox(height: 40,),
                    ],
                  ),
                ],
              )
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
          ),
          SizedBox(height: 200,)

        ],
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
      //transfering= true;
    });
    if(balanceRopsten=="0"||balanceRopsten=="0.0"){
      Toast.show("Insufficient Funds", context);
    }
    else{
      EthWrapper wrapper = new EthWrapper();
      await wrapper.depositERC20(double.parse(_amount.text),).then((val){
        print("wallet:" +val);
        _refreshTx();
        setState(() {
          txDeposit=val;
        });
      });
    }

   _refreshTx();
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
  _allow()async {
    EthWrapper wrapper = new EthWrapper();
    await wrapper.checkEth().then((val)async{
      BigInt wei = val;
      if(balanceRopsten=="0"||balanceRopsten=="0.0"){
        Toast.show("Insufficient Funds", context);
      }
      else{

        if(wei<BigInt.from(1500000000000000)){
          _asyncConfirmDialog(context);
        }
        else{
          EthWrapper wrapper = new EthWrapper();
          await wrapper.allowanceToken().then((val)async{
            SharedPreferences prefs =await SharedPreferences.getInstance();
            prefs.setBool("allow", false);
            prefs.setBool("transacting", true);
            setState(() {
              allowance= false;
            });
            _refreshTx();
          });


          Toast.show("In Proccess, wait for 2 minutes", context,duration: Toast.LENGTH_LONG);

        }
      }
    });
  }
  _incAllow()async {
    EthWrapper wrapper = new EthWrapper();
    await wrapper.checkEth().then((val)async{
      BigInt wei = val;
      if(balanceRopsten=="0"||balanceRopsten=="0.0"){
        Toast.show("Insufficient Funds", context);
      }
      else{

        if(wei<BigInt.from(1500000000000000)){
          _asyncConfirmDialog(context);
        }
        else{
          EthWrapper wrapper = new EthWrapper();
          await wrapper.incAllowanceToken().then((val)async{
            SharedPreferences prefs =await SharedPreferences.getInstance();
            //prefs.setBool("allow", false);
            prefs.setBool("transacting", true);
            setState(() {
              err= false;
            });
            _refreshTx();
          });


          Toast.show("In Proccess, wait for 2 minutes", context,duration: Toast.LENGTH_LONG);

        }
      }
    });
  }
  _approveAll()async {
    print("called");
    EthWrapper wrapper = new EthWrapper();
    await wrapper.checkEth().then((val)async{
      BigInt wei = val;
      if(balanceRopsten=="0"||balanceRopsten=="0.0"){
        Toast.show("Insufficient Funds", context);
      }
      else{
        if(wei<BigInt.from(1500000000000000)){
          _asyncConfirmDialog(context);
        }
        else{
          EthWrapper wrapper = new EthWrapper();
          await wrapper.approveToken(double.parse(balanceRopsten));
          SharedPreferences prefs =await SharedPreferences.getInstance();
          prefs.setBool("approve", false);
          prefs.setBool("transacting", true);
          setState(() {
            approve = false;
          });
          _refreshTx();
          Toast.show("In Proccess, wait for 2 minutes", context,duration: Toast.LENGTH_LONG);

        }
      }

    });
  }
  _refreshTx(){
    transacting =false;
    json={"result":{"status":"0"}};
    loading=0;
    _getApproveStatus().then((val){
      setState(() {
        loading++;
        approve =val;
      });

    });
    _getAllownceStatus().then((val){
      setState(() {
        loading++;
        allowance =val;
      });

    });
    _getHash().then((str){
      setState(() {
        loading++;
        hash= str;
      });
    });
    _getStatus().then((val){
      setState(() {
        loading++;
        transacting= val;
      });

    });
    _getTransaction().then((json){
      setState(() {
        loading++;
        //this.json= json;
        print("check3:"+this.json.toString());
        _check();
      });
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

