import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/moonPayWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BuyandSell extends StatefulWidget {
  @override
  _BuyandSellState createState() => _BuyandSellState();
}

class _BuyandSellState extends State<BuyandSell> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  _getCard()async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    MoonPayWrapper wrapper = new MoonPayWrapper();
    var js = await wrapper.getCardList(jwt);
    print(js);
  }
  @override
  void initState() {
    _getCard();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Deposit to Ropsten",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                        hintText: "DAIs to Deposit",
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
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Withdraw from Ropsten",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                 child: TextField(
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15,10,15,10),
                        hintText: "DAIs to Deposit",
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
      ),
    );
  }
}
