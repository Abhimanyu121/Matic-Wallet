import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class loader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/matic.png'),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo,
              SpinKitCircle(size:50, color: Colors.blueAccent,)
            ],
          ),
        ),
      ),
    );
  }

}