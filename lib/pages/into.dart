//import 'dart:html';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/pages/main_page.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();

   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   _firebaseMessaging.requestNotificationPermissions(   );

    _firebaseMessaging.getToken().then((value) {
      debugPrint('Token FCB=$value');
      _prefs.then((x) {
        x.setString('fcmKey', value);
      });
    });


    auth.checkAuth().then((value) async {
      // Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
      Future.delayed(Duration(seconds: 3)).then((s) {
        if(value){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainPage(firebaseMessaging: _firebaseMessaging,),));
        }else{
          Navigator.of(context).pushReplacementNamed('/register');
        }
      });


    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:       Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: PColor.orangeparto,
        child: Center(
          child: Text('پرتو پرداخت',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
        ),
      )
      ,
    );
  }
}
