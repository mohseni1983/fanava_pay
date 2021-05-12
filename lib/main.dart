import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fanava_payment/UI/cust_colors.dart';
import 'package:fanava_payment/classes/auth.dart' as auth;
import 'package:fanava_payment/classes/internet_package.dart';
import 'package:fanava_payment/classes/global_variables.dart' as globalVars;
import 'package:fanava_payment/pages/charge.dart';
import 'package:fanava_payment/pages/donation.dart';
import 'package:fanava_payment/pages/ghobooz.dart';
import 'package:fanava_payment/pages/internet_package.dart';
import 'package:fanava_payment/pages/into.dart';
import 'package:fanava_payment/pages/main_page.dart';
import 'package:fanava_payment/pages/notifications.dart';
import 'package:fanava_payment/pages/profile.dart';
import 'package:fanava_payment/pages/registeration.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() async {

  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SentryFlutter.init(
          (options) {
        options.dsn = 'https://87a232be89fe4af1beb7a10c5be27cef@o502350.ingest.sentry.io/5635538';
      },
      appRunner: () {

        runApp(MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: PColor.orangeparto,
              backgroundColor: Color.fromRGBO(233, 233, 233, 1),
              primaryColor: PColor.orangeparto,
              accentColor: PColor.blueparto,
              fontFamily: 'IRANSans(FaNum)',
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: PColor.orangeparto,style: BorderStyle.solid,width: 2.0),
                ),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey,style: BorderStyle.solid,width: 3.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: PColor.blueparto,style: BorderStyle.solid,width: 2.0)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: PColor.orangeparto,style: BorderStyle.solid,width: 2.5)
                ),
                fillColor: PColor.orangepartoAccent,
                focusColor: PColor.orangepartoAccent.shade200,
                hoverColor: PColor.orangepartoAccent.shade400,
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(25, 1, 25, 1),
              ),
              textTheme: TextTheme(
                  caption: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    color: PColor.blueparto,
                  ),
                  subtitle1: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: PColor.blueparto,
                  ),
                  headline1: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: PColor.blueparto,
                  )
              )

          ),
          routes: {
            '/intro':(context)=>IntroPage(),
            '/':(context)=>MainPage(),
            '/register':(context)=>RegisterationPage(),
            '/bill':(context)=>BillsPage(),
            '/charge': (context)=>ChargeWizardPage(),
            '/internet':(context)=>InternetPackagePage(),
            '/wallet':(context)=>ProfilePage(),
            '/profile':(context)=>ProfilePage(),
            '/donation':(context)=>DonationPage(),
            '/notifications':(context)=>NotificationsPage(),
          },
          initialRoute: '/intro',


          // home:value? new MainPage():new RegisterationPage(),
        ),);

      }
    //appRunner: () => runApp(new MainPage(),),

  );


}

/*class MyAppAuthunticated extends StatelessWidget {

  const MyAppAuthunticated({Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'پرداخت پرتو',
      theme: ThemeData(
        primarySwatch: PColor.orangeparto,
        backgroundColor: Color.fromRGBO(233, 233, 233, 1),
        primaryColor: PColor.orangeparto,
        accentColor: PColor.blueparto,
        fontFamily: 'IRANSans(FaNum)',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            borderSide: BorderSide(color: PColor.orangeparto,style: BorderStyle.solid,width: 2.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.grey,style: BorderStyle.solid,width: 3.0)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: PColor.blueparto,style: BorderStyle.solid,width: 2.0)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: PColor.orangeparto,style: BorderStyle.solid,width: 2.5)
          ),
          fillColor: PColor.orangepartoAccent,
          focusColor: PColor.orangepartoAccent.shade200,
          hoverColor: PColor.orangepartoAccent.shade400,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(25, 1, 25, 1),
        ),
        textTheme: TextTheme(
          caption: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14.0,
            color: PColor.blueparto,
          ),
          subtitle1: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
            color: PColor.blueparto,
          ),
          headline1: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: PColor.blueparto,
          )
        )

      ),


      home: MainPage(),
    );



    }
}*/

/*
class MyAppNotAuthunticated extends StatelessWidget {

  const MyAppNotAuthunticated({Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'پرداخت پرتو',
        theme: ThemeData(
            primarySwatch: PColor.orangeparto,
            backgroundColor: Color.fromRGBO(233, 233, 233, 1),
            primaryColor: PColor.orangeparto,
            accentColor: PColor.blueparto,
            fontFamily: 'IRANSans(FaNum)',
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(color: PColor.orangeparto,style: BorderStyle.solid,width: 2.0),



              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey,style: BorderStyle.solid,width: 3.0)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: PColor.blueparto,style: BorderStyle.solid,width: 2.0)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: PColor.orangeparto,style: BorderStyle.solid,width: 2.5)
              ),
              fillColor: PColor.orangepartoAccent,
              focusColor: PColor.orangepartoAccent.shade200,
              hoverColor: PColor.orangepartoAccent.shade400,
              filled: true,
              contentPadding: EdgeInsets.fromLTRB(25, 1, 25, 1),





            ),
            textTheme: TextTheme(
                caption: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: PColor.blueparto,

                ),
                subtitle1: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: PColor.blueparto,

                ),
                headline1: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: PColor.blueparto,

                )
            )

        ),


        home: RegisterationPage(),
      );



  }
}
*/


