import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parto_v/classes/profile.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice.dart';
//import 'package:parto_v/pages/charge.dart';
import 'package:parto_v/pages/internet_package.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:parto_v/classes/wallet.dart';

import 'charge.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override
  void didUpdateWidget(MainPage oldWidget) {
    setWalletAmount();
    setState(() {

    });
  }



  @override
  void initState() {
    // TODO: implement initState

    setWalletAmount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MasterTemplate(
            isHome: true,
            wchild: GridView.count(
              crossAxisCount: 2,
              padding:
                  EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 50),
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChargeWizardPage(),
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                        color: PColor.orangeparto,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: PColor.blueparto,
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(0, 0))
                        ]),
                    child: Center(
                      child: Text(
                        ' خرید شارژ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InternetPackagePage(),
                  )),
                  child: Container(
                    decoration: BoxDecoration(
                        color: PColor.orangeparto,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                              color: PColor.blueparto,
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(0, 0))
                        ]),
                    child: Center(
                      child: Text(
                        ' خرید بسته اینترنت',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                )

              ],
            )),
        onWillPop: () => _onWillPop());
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
            context: context,
            builder: (context) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: Text('آیا اطمینان دارید؟'),
                    content: Text('آیا می خواهید از اپ خارج شوید'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('خیر'),
                      ),
                      FlatButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text('بلی'),
                      ),
                    ],
                  ),
                )) ??
        false;
  }
}
