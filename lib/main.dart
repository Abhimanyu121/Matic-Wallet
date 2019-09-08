import 'package:crypto_app_ui/screens/home.dart';
import 'package:crypto_app_ui/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/loader.dart';
import 'package:crypto_app_ui/screens/login1.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int state = 1;//1=loader 2= login 3 = main
  bool isDark = false;
  _checkState() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var ppk = prefs.getString("privateKey");
    if(ppk ==""||ppk==null){
      setState(() {
        state =2;
      });
    }
    else{
      setState(() {
        state =3;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.darkPrimary : Constants.lightPrimary,
      statusBarIconBrightness: isDark?Brightness.light:Brightness.dark,
    ));
    _checkState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: isDark ? Constants.darkTheme : Constants.lightTheme,
      home: state==1?loader():(state==2?Login_email():Home()),
    );
  }
}

