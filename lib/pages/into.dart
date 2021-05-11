//import 'dart:html';
import 'dart:async';
import 'dart:io';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:root_access/root_access.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/pages/main_page.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  bool isRoot=false;
  bool noInternet=false;
  bool useVpn=false;

   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

   Future<bool> isDeviceRoot() async{
     if(Platform.isAndroid){
       return await RootAccess.rootAccess;
     }else
     return false;
   }

   Future<bool> isInternetConnected() async {
     var status= await Connectivity().checkConnectivity();
     if(status==ConnectivityResult.none){
       return false;
     }else{
       return true;
     }
   }

   Future<bool> isVpnConnected() async {
     return await CheckVpnConnection.isVpnActive();
   }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDeviceRoot().then((rooted) {
      if(rooted){
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return CAlertDialog(
              content: 'خطای مهم',
              subContent: 'گوشی شما دارای دسترسی روت می باشد. برای استفاده از اپ گپشی نباید روت باشد',
              buttons: [
                CButton(
                  label: 'خروج',
                  onClick: (){
                    exit(0);
                  },
                )
              ],
            );
          },
        ).then((value) => exit(0));
      }else{
        isVpnConnected().then((vpn) {
          if(vpn){
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              // false = user must tap button, true = tap outside dialog
              builder: (BuildContext dialogContext) {
                return CAlertDialog(
                  content: 'خطای مهم',
                  subContent: 'شما در حال استفاده از VPN هستید. لطفا وی پی ان را قطع نمایید.',
                  buttons: [
                    CButton(
                      label: 'خروج',
                      onClick: (){
                        exit(0);
                      },
                    )
                  ],
                );
              },
            ).then((value) => exit(0));
          } else{
            isInternetConnected().then((connected) {
              if(!connected){
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  // false = user must tap button, true = tap outside dialog
                  builder: (BuildContext dialogContext) {
                    return CAlertDialog(
                      content: 'خطای مهم',
                      subContent: 'اتصال اینترنت گوشی برقرار نمی باشد.',
                      buttons: [
                        CButton(
                          label: 'خروج',
                          onClick: (){
                            exit(0);
                          },
                        )
                      ],
                    );
                  },
                ).then((value) => exit(0));

              }else{
                _firebaseMessaging.requestNotificationPermissions();
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
            });
          }
        });
      }
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:       Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: PColor.orangeparto.shade200,
        child: Center(
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        alignment: Alignment.center,

                      )
                  ),
                ),
                Text('پرتو پرداخت')

              ],
            )
        ),
      )
      ,
    );
  }
}
