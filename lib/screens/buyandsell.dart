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
  bool loading=false;
  bool fetching =true;
  var _cardNo = new TextEditingController();
  var _cvv = new TextEditingController();
  var _expiry = new TextEditingController();
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

      body: fetching?
      _loader():
          Column(
            children: <Widget>[
              ls.length==1?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.add),
                          Text("Add Card")
                        ],
                      ),
                      onPressed: (){
                        _asyncInputDialog(context).then((str){
                          if(str =="Done!")
                            _refresh();
                        });
                      },
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  )
                ],
              ):SizedBox(

              ),
              Expanded(
                child: ListView.builder(
                  primary:  false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ls.length,
                    itemBuilder: (context , position){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CardWidget(ls[position]["lastDigits"].toString(), ls[position]["id"].toString(), ls[position]["expiryYear"].toString()),
                      );
                    }
                ),
              ),
            ],
          )

    );
  }
  Future<String> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Card details'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: _cards(),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Add Card"),
              onPressed: () async {
                setState(() {
                  loading=true;
                });
                MoonPayWrapper wrapper = new MoonPayWrapper();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String jwt = prefs.getString("jwt");
                await wrapper.addCard2(jwt).then((boolean){
                print("login valeue:"+boolean.toString());
                Navigator.of(context).pop("Done!");

                });
              })
          ],
        );
      },
    );
  }
  _cards(){

    final cardNo = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => val.length!=19
          ? 'Not a valid email.'
          : null,
      decoration: InputDecoration(
        hintText: 'Card Number (XXXX XXXX XXXX XXXX)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _cardNo,
    );
    final cvv = TextFormField(
      keyboardType: TextInputType.number,
      autovalidate: true,
      validator: (val) => val.length!=3
          ? 'Invalid CVV.'
          : null,
      decoration: InputDecoration(
        hintText: 'CVV',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _cvv,
    );
    final expiry = TextFormField(
      keyboardType: TextInputType.text,
      autovalidate: true,
      validator: (val) => val.length!=7
          ? 'Invalid Date'
          : null,
      decoration: InputDecoration(
        hintText: 'Expiry Date MM/YYYY',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0)),
      ),
      controller: _expiry,
    );
    return Column(
      children: <Widget>[

        cardNo,
        SizedBox(height: 8.0),
        cvv,
        SizedBox(height: 8.0),
        expiry,
        SizedBox(height: 8.0),
        loading?SpinKitChasingDots(size: 30,color: Colors.blue,):SizedBox(height: 1,)



      ],
    );
  }
  _refresh(){
    setState(() {
      fetching =true;
    });
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
  _loader(){
    return Center(
      child: SpinKitChasingDots(size:60, color : Colors.blue),
    );
  }
}
