import 'package:bip39/bip39.dart' as bip39;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
class KeyInterface {
  Future<String> generateKey()async {
    var mnemonic = bip39.generateMnemonic();
    print(mnemonic);
    String privatekey= bip39.mnemonicToSeedHex(mnemonic);
    Credentials fromHex = EthPrivateKey.fromHex(privatekey);
    var address = await fromHex.extractAddress();
    print(address);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", address.toString());
    prefs.setString("privateKey", privatekey.toString() );
    return mnemonic.toString();
  }
  Future<String> fromMenmonic(mnemonic)async {
    String privatekey= bip39.mnemonicToSeedHex(mnemonic);
    print(privatekey);
    Credentials fromHex = EthPrivateKey.fromHex(privatekey);
    var address = await fromHex.extractAddress();
    print(address);
  }
}