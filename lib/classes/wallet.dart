import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parto_v/classes/convert.dart';
import 'package:parto_v/classes/global_variables.dart';
import 'package:parto_v/classes/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:http/http.dart' as http;
Future<void> setWalletAmount(State state) async{
  debugPrint('Start updating wallet amount====================================================');
  auth.checkAuth().then((value) async{
    if (value) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String _sign = _prefs.getString('sign');
      String _token = _prefs.get('token');
      var _body={
        "LocalDate": DateTime.now().toString(),
        "Sign": _sign,
        "UseWallet": true
      };
      var _jBody=json.encode(_body);
      var result = await http.post(
          'https://www.idehcharge.com/Middle/Api/Charge/GetOwnerInfo',
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json'
          },
          body: _jBody
      );
      if(result.statusCode==200){
        //debugPrint(result.body);
        var jres=json.decode(result.body);
        if(jres['ResponseCode']==0){
          var x=profileInfoFromJson(result.body);
         // debugPrint('Stop updating wallet amount ==========================================');

          state.setState(() {
            globWalletAmount=x.deviceInfo.credit>0?getMoneyByRial((x.deviceInfo.credit~/10).toInt()):"0" ;
            _prefs.setString('cellNumber', '0${x.deviceInfo.cellNumber}');

          });
          //_prefs.setDouble('wallet_amount', x.deviceInfo.credit);








        }

      }
    }
  });


}
