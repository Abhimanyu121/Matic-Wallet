import 'package:crypto_app_ui/widgets/wallet.dart';
import 'package:flutter/material.dart';



class Wallets extends StatefulWidget {
  @override
  _WalletsState createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        children: <Widget>[
          Wallet(
            name: "Ropsten",
            icon: "assets/eth.png",
            amount : "123"
          ),
          Wallet(
              name: "Matic",
              icon: "assets/matic.png",
              amount : "696969696969"
          )
        ],
      ),
    );
  }
}

