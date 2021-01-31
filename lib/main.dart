import 'dart:convert';
 import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/components/reg_page_template.dart';
import 'package:parto_v/UI/cust_colors.dart';
import 'package:parto_v/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:parto_v/classes/auth.dart' as auth;

import 'custom_widgets/cust_alert_dialog.dart';
import 'custom_widgets/cust_button.dart';
import 'custom_widgets/cust_textfield.dart';
import 'pages/enter_otp.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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


      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  bool _isAuthunticated=false;

  bool _progressing=false;
  TextEditingController _mobile=new TextEditingController();
  DeviceInfoPlugin plugin=new DeviceInfoPlugin();
  String _deviceId='---';
  int os_id=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      if(Platform.isAndroid){
        plugin.androidInfo.then((value) {
          setState(() {
            _deviceId=value.androidId;
            os_id=1;
          });
          debugPrint(value.androidId);
        });
      }else if (Platform.isIOS){
        plugin.iosInfo.then((value) {
          setState(() {
            _deviceId=value.identifierForVendor;
            os_id=2;

          });
          debugPrint(value.identifierForVendor);
        });
      }

    }on PlatformException {
      setState(() {
        _deviceId='Error';
      });

    }
    _prefs.then((value) {
      var _sign=value.getString('sign');
      
      if(value.containsKey('token'))
        auth.checkAuth().then((value) {
          if(value)
            setState(() {
              _isAuthunticated=true;
            });
        }

        );


    });

  }

  Future<void> sendMobileNumber() async {
    setState(() {
      _progressing=true;
    });
    var _cellNumber=_mobile.text.substring(1,11);
    var _devId=_deviceId;
    var result=await http.post('https://www.idehcharge.com/Middle/Api/Charge/Register',body: {

      "CellNumber": _cellNumber,
      "DeviceKey": _devId,
      "Os": "$os_id"


    });
    if(result.statusCode==200){

      //debugPrint(result.body);
      var res=json.decode(result.body);
      if(res['ResponseCode']==0)
      _prefs.then((value){
        value.setString('username', _cellNumber);
        value.setString('device_id', _devId);
        value.setInt('os', os_id);
        setState(() {
          _progressing=false;
        });
        //debugPrint('Sended');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EnterOTP()));
      });
      else{
        setState(() {
          _progressing=false;
        });

        showDialog(context: context,
        builder: (context) => CAlertDialog(
          content: res['ResponseMessage'],
          buttons: [
            CButton(label: 'قبول',onClick: ()=>Navigator.of(context).pop(),)
          ],
        ),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
  if( _isAuthunticated)
        return MainPage();
  else
          return
     ModalProgressHUD(
      child:

      RegPageTemplate(
        children: [
          Text('برای ورود یا ثبت نام شماره همراه خود را وارد کنید',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,textScaleFactor: 0.9,),
          CTextField(textAlign: TextAlign.center,controller: _mobile,maxLenght: 11,keyboardType: TextInputType.phone,),
          Padding(padding: EdgeInsets.only(top: 3)),
          CButton(onClick: (){
            if(_mobile.text.length==11 && _mobile.text.startsWith('09'))

              showDialog(context: context,
           builder: (context) {

             return CAlertDialog(
               content: 'آیا از صحت شماره همراه وارد شده اطمینان دارید؟',
               subContent: '${_mobile.text}',
               buttons: [
                 CButton(onClick: (){Navigator.of(context).pop();},label: 'ویرایش',minWidth: 120,),

                 CButton(onClick: (){
                   sendMobileNumber();



                   Navigator.of(context).pop();
                   },label: 'ادامه',minWidth: 120,),

               ],
             );
           },
           );
            else
              showDialog(context: context,
                builder: (context) => CAlertDialog(content:'خطا',subContent: 'شماره موبایل وارد شده صحیح نیست',buttons: [CButton(label: 'اصلاح',onClick: ()=>Navigator.of(context).pop(),)],),
              );
          },label: 'ورود',minWidth: MediaQuery.of(context).size.width,)

        ],
      ),
      inAsyncCall: _progressing, )
    ;
  }


}
