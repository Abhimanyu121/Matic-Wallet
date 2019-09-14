import 'package:foreground_service/foreground_service.dart';
import 'dart:io';
import 'package:crypto_app_ui/wrappers/ethWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto_app_ui/wrappers/ScannerWRapper.dart';


class depositBg{
  init(double amount){
    initapproval(amount);
  }
  initapproval(double amount)async {
    EthWrapper wrapper = new EthWrapper();
    await wrapper.approveToken(amount).then((hash){
      print(hash);
      while(hash==null);
      check(hash);
      return hash;
    });

  }
  Future<bool> check(String hash)async {
    ScannerWrapper wrapper = new  ScannerWrapper();
     var json =await wrapper.getDetails(hash);
      print(json);
     if(json["result"]["status"]=="1"){
       initallow();
       return true;
     }
     else if(json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
       return false;
     }
     else{
       check(hash);
     }
  }
  Future<String> initallow()async {
    EthWrapper wrapper = new EthWrapper();
    await wrapper.allowanceToken().then((hash) {
      print(hash);
      while(hash==null);
      checkAllow(hash);
      return hash;
    });
  }
  Future<bool> checkAllow(String hash)async {
    ScannerWrapper wrapper = new  ScannerWrapper();
    var json =await wrapper.getDetails(hash);
    print(json);
    if(json["result"]["status"]=="1"){
      increaseAllow();
      return true;
    }
    else if(json["message"]=="NOTOK"||json["result"]["Status"]=="0"){
      return false;
    }
    else{
      checkAllow(hash);
    }
  }
  Future<String> increaseAllow()async {
    EthWrapper wrapper = new EthWrapper();
    await wrapper.incAllowanceToken().then((hash){
      print(hash);
      while(hash==null);
      return hash;
    });
  }


}