import 'package:flutter/material.dart';
import 'package:crypto_app_ui/wrappers/moonPayWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Card_widget.dart';
class BuyandSell extends StatefulWidget {
  @override
  _BuyandSellState createState() => _BuyandSellState();
}

class _BuyandSellState extends State<BuyandSell> {
  List ls;
  bool fetching =true;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  _getCard() async  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    MoonPayWrapper wrapper = new MoonPayWrapper();
    List js =  await wrapper.getCardList(jwt);
    return js;
  }
  @override
  void initState() {
    _getCard().then((val){

      setState(() {
        ls =val;
        for(int i = ls.length;i>2;i--){
          ls.removeLast();
        }
        fetching =false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: fetching?_loader():ListView.builder(
          itemCount: ls.length,
          itemBuilder: (context , position){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CardWidget(ls[position]["lastDigits"].toString(), ls[position]["id"].toString(), ls[position]["expiryYear"].toString()),
            );
          }
      ),
    );
  }
  _loader(){
    return Center(
      child: SpinKitChasingDots(size:60, color : Colors.blue),
    );
  }
}
