import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';


class Wallet extends StatefulWidget {
  final String name;
  final String icon;
  final String amount;
  Wallet({
    Key key,
    this.name, this.icon, this.amount
  }) : super(key: key);


  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {




  @override
  Widget build(BuildContext context) {
    return Card(
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
                      "${widget.icon}",
                      height: 30,
                      width: 25,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "${widget.name}",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),

                  ],
                ),
                int.parse("${widget.amount}")==696969696969? _loader():Text(""+(int.parse("${widget.amount}")*70).toString()+" INR"),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              child: int.parse("${widget.amount}")==696969696969? _loader():Text("${widget.amount}"+" DAI", style: TextStyle(fontSize: 30),),
            ),
          ),

          RaisedButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(200),
            ),
            color: Colors.blueAccent,
            child: "${widget.name}"=="Ropsten"? Text("Transfer to Matic"):Text("Transfer to Ropsten"),
            onPressed: (){},
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
  _loader(){
    return SpinKitFoldingCube(size: 30,color: Colors.indigo,);
  }
}
class LinearToken {
  final int day;
  final int value;

  LinearToken(this.day, this.value);
}