import 'package:flutter/material.dart';
import 'package:parto_v/Pages/Charge.dart';
import 'package:parto_v/UI/Widgets/CAlertDialog.dart';
import 'package:parto_v/UI/Widgets/CButton.dart';

import 'Components/OperativePagesTemplate.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: OperativePagesTemplate(
      child: Expanded(
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CButton(
                  label: 'شارژ',
                  onClick: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChargePage(),));
                  },
                ),
                CButton(
                  label: 'بسته اینترنت',
                  onClick: (){},
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CButton(
                  label: 'قبض',
                  onClick: (){},
                ),
                CButton(
                  label: 'مانده کارت',
                  onClick: (){},
                ),

              ],
            ),



          ],
        ),
      )
    ),

        onWillPop: ()=>showDialog(context: context,
        builder: (context) => CAlertDialog(
          content: 'آیا می خواهید از اپ خارج شوید',
        ) ,
        ));
  }
}
