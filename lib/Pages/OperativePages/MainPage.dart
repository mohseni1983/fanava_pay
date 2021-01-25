import 'package:flutter/material.dart';
import 'package:parto_v/UI/Widgets/CAlertDialog.dart';

import 'Components/OperativePagesTemplate.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: OperativePagesTemplate(
      child: Center(child: Text('Hello World'),),
    ),

        onWillPop: ()=>showDialog(context: context,
        builder: (context) => CAlertDialog(
          content: 'آیا می خواهید از اپ خارج شوید',
        ) ,
        ));
  }
}
