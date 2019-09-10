import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_app_ui/screens/buyandsell.dart';
import 'package:crypto_app_ui/screens/transactions.dart';
import 'package:crypto_app_ui/screens/wallets.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  String email;
  String address;
  _loademail()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }
  _loadaddress()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("address");
  }
  @override
  void initState()  {
    _loadaddress().then((val){
     setState(() {
       address = val;
     });
     _loademail().then((value){
       setState(() {
         email = value;
         _loading= false;
       });
     });
   });


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          shape: RoundedRectangleBorder(),
        leading:  SizedBox(
          width: 200,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/matic.png",),
            radius: 25,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              ClipboardManager.copyToClipBoard(address).then((asd){
                Toast.show("Address copied", context);
              });
            },
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                _loading?Text("Loading.."):Text(email, style: TextStyle(fontSize: 10),),
                _loading?Text("Loading.."):Text(address.toUpperCase(),style: TextStyle(fontSize: 10),maxLines: 2,),
              ],
            ),
          ),

            FlatButton(
              child: Text("LOG OUT"),
              onPressed: ()async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("privateKey", "");
                Toast.show("Please restart app", context, duration:Toast.LENGTH_LONG);
              },
            )
          ],

//
      ),


      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[


          Align(
            alignment: Alignment.center,
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TabBar(
                    isScrollable: false,
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor: Theme.of(context)
                        .textTheme.caption.color,
                    tabs: <Widget>[
                      Tab(
                        text: "Wallets",
                      ),
                      Tab(
                        text: "Transactions",
                      ),
                      Tab(
                        text: "Cards",
                      ),
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height*1,
                    child: TabBarView(
                      children: <Widget>[
                        Wallets(),
                        Transactions(),
                        BuyandSell(),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
