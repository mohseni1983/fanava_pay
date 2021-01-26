import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/pages/charge.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
        MasterTemplate(
          wchild:       ListView(
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

        ),
        onWillPop: ()=>_onWillPop()
    );
  }


  Future<bool> _onWillPop() async {
    return await
      showDialog(
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
