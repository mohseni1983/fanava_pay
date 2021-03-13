import 'package:flutter/material.dart';
import 'package:parto_v/classes/recipt.dart';
import 'package:parto_v/pages/main_page.dart';

class ReciptPage extends StatefulWidget {
  final String url;
  

  const ReciptPage({Key key, this.url}) : super(key: key);
  @override
  _ReciptPageState createState() => _ReciptPageState();
}

class _ReciptPageState extends State<ReciptPage> {
  Recipt _recipt=new Recipt();


  @override
  void initState() {
    super.initState();
    setState(() {
     // _recipt=reciptFromJson(Uri.decodeComponent(widget.url.replaceAll('partov://idehcharge.com?transactiondata=', '')));
      debugPrint(widget.url);
     // debugPrint(Uri.decodeComponent(widget.url.replaceAll('partov://idehcharge.com?transactiondata=', '')));
    });
  }

  Widget build(BuildContext context) {
    return 
        WillPopScope(child:       
        Directionality(textDirection: TextDirection.rtl, child: Scaffold(
          body: Center(
            child: Text(_recipt.traceNumber??''),
          ),

        )
        ),
          onWillPop: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),)),
    );
  }
}
