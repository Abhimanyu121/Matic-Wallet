import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_app_ui/wrappers/moonPayWrapper.dart';
import 'package:toast/toast.dart';
class CardWidget extends StatefulWidget{
  String cardDigit;
  String year;
  String cardId;
  CardWidget(String cardDigit,String cardId, String year){
    this.cardDigit= cardDigit;
    this.year = year;
    this.cardId = cardId;
  }
  @override
  CardWidgetUi createState() => new CardWidgetUi(cardDigit, cardId, year);
}
class CardWidgetUi extends State<CardWidget>{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
  String cardDigit;
  String year;
  String cardId;
  CardWidgetUi(String cardDigit,String cardId, String year){
    this.cardDigit= cardDigit;
    this.year = year;
    this.cardId = cardId;
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController _amount = new TextEditingController();
    // TODO: implement build
    return Card(
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
            padding: const EdgeInsets.fromLTRB(19.0,5.0,19.0,5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  "assets/visa.png",
                  height: 30,
                  width: 25,
                ),
                Text("Visa",style: TextStyle(fontWeight: FontWeight.w300),)
              ],
            ),
          ),
          Text("XXXX XXXX XXXX "+cardDigit, style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(
            height: 20,
          ),
          Text("Expiry Year: "+year,),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              obscureText: false,
              controller: _amount,
              autovalidate: true,
              validator: (val)=> val==""?null:(int.parse(val)>=20?null:"Should be at least 20"),
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
              onPressed: ()async{
                await SharedPreferences.getInstance().then((prefs){
                  var address = prefs.getString("address");
                  var jwt = prefs.getString("jwt");
                  var amount = _amount.text.toString();
                  print(cardId);
                  MoonPayWrapper wrapper = new MoonPayWrapper();
                  wrapper.addMoney(jwt, amount, address, cardId).then((val){
                    if(val){
                      Toast.show("Done!", context,duration: Toast.LENGTH_LONG);
                    }
                    else{
                      Toast.show("Something went wrong :(", context,duration: Toast.LENGTH_LONG);
                    }
                  });


                });
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Transact', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

}