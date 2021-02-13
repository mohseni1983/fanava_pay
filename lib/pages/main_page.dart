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
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              padding:
                  EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 50),
              children: [
                MainIcon(
                  label: 'شارژ سیم کارت',
                  image: AssetImage('assets/images/sim-Charge.png'),
                  onPress: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChargeWizardPage(),)),
                ),
                MainIcon(
                  label: 'بسته اینترنت',
                  image: AssetImage('assets/images/3g4g5g.png'),
                  onPress: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetPackagePage(),)),
                ),
                MainIcon(
                  label: 'قبوض خدماتی',
                  image: AssetImage('assets/images/ghobooz2.png'),
                  onPress: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetPackagePage(),)),
                ),
                MainIcon(
                  label: 'نیکوکاری',
                  image: AssetImage('assets/images/3g4g5g.png'),
                  onPress: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetPackagePage(),)),
                ),




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


class MainIcon extends StatefulWidget {
  final String label;
  final AssetImage image;
  final VoidCallback onPress;

  const MainIcon({Key key, this.label, this.image, this.onPress}) : super(key: key);
  @override
  _MainIconState createState() => _MainIconState();
}

class _MainIconState extends State<MainIcon> {
  @override
  Widget build(BuildContext context) {
    return                 GestureDetector(
      onTap: widget.onPress,
      child: Container(

          child: Stack(
            children: [
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 10,left: 10),
                    height: MediaQuery.of(context).size.width/2.5,
                    width: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(
                      color: PColor.orangeparto,
                      borderRadius: BorderRadius.circular(15),

                    ),
                    child: Column(
                      children: [
                        Expanded(child: Container(height: 0,)),
                        Container(
                          margin: EdgeInsets.only(bottom: 5,left: 3,right: 3),
                          child:  Text('${widget.label}',style: TextStyle(color: PColor.blueparto),textScaleFactor: 1.1,),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 0,
                  left: 0,

                  child: Container(
                    height: MediaQuery.of(context).size.width/3.1,
                    width: MediaQuery.of(context).size.width/3.1,
                    decoration: BoxDecoration(
                        color: PColor.blueparto.withAlpha(80),
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image:widget.image,
                            fit: BoxFit.contain
                        )

                    ),
                  )),
            ],

          )
      ),
    );

  }
}
