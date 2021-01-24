import 'package:flutter/material.dart';
import 'package:parto_v/Pages/RegisterPages/Components/RegPageTemplate.dart';
import 'package:parto_v/UI/Colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: PColor.orangeparto,
        backgroundColor: Color.fromRGBO(233, 233, 233, 1),
        primaryColor: PColor.orangeparto,
        accentColor: PColor.blueparto,
        fontFamily: 'IRANSans(FaNum)'
      ),
      home: MyHomePage(title: 'نرم افزار پرتو'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return RegPageTemplate(
      children: [
        Text('این یک تست است'),
      ],
    );
  }
}
