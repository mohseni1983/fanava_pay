import 'package:flutter/material.dart';
import './HeaderBack.dart';
import './TopWallet.dart';
import './MainFooterOfApp.dart';

class OperativePagesTemplate extends StatefulWidget {
  final Widget child;

  const OperativePagesTemplate({Key key, this.child}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<OperativePagesTemplate> {
  @override
  Widget build(BuildContext context) {
    return
      Directionality(textDirection: TextDirection.rtl,
          child:       Scaffold(
            //backgroundColor: const Color(0xffe9e9e9),
            body: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:200.0*MediaQuery.of(context).size.width/375.0,bottom: 91.0*MediaQuery.of(context).size.width/375.0 ),

                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200.0*MediaQuery.of(context).size.width/375.0,
                  child: HeaderBack(),
                ),
                Transform.translate(
                  offset: Offset(121.0*MediaQuery.of(context).size.width/375, 31.0*MediaQuery.of(context).size.height/812),
                  child: SizedBox(
                    width: 133.0*MediaQuery.of(context).size.width/375,
                    height: 123.0*MediaQuery.of(context).size.height/812,
                    child: TopWallet(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0.0, 721.0*MediaQuery.of(context).size.height/812),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 91.0*MediaQuery.of(context).size.width/375.0,
                    child: MainFooterOfApp(),
                  ),
                ),
              ],
            ),
          )
      )
    ;
  }

}
