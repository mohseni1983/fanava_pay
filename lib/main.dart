import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parto_v/Pages/main_page.dart';
import 'package:parto_v/UI/cust_colors.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:parto_v/Pages/registeration.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  auth.checkAuth().then((value) async {
    await SentryFlutter.init(
          (options) {
        options.dsn = 'https://87a232be89fe4af1beb7a10c5be27cef@o502350.ingest.sentry.io/5635538';
      },
      appRunner: () =>value? runApp(MyAppAuthunticated(),):runApp(MyAppNotAuthunticated()),
    );
    ;
  });
}

class MyAppAuthunticated extends StatelessWidget {

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
}

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


