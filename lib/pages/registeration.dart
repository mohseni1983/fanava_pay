import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fanava_payment/components/reg_page_template.dart';
import 'package:fanava_payment/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:fanava_payment/classes/auth.dart' as auth;
import 'package:fanava_payment/custom_widgets/cust_alert_dialog.dart';
import 'package:fanava_payment/custom_widgets/cust_button.dart';
import 'package:fanava_payment/custom_widgets/cust_textfield.dart';
import 'package:fanava_payment/pages/enter_otp.dart';

class RegisterationPage extends StatefulWidget {
  @override
  _RegisterationPageState createState() => _RegisterationPageState();
}
class _RegisterationPageState extends State<RegisterationPage> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  bool _isAuthunticated=false;
  bool _progressing=false;
  TextEditingController _mobile=new TextEditingController();
  DeviceInfoPlugin plugin=new DeviceInfoPlugin();
  String _deviceId='---';
  int os_id=0;
  String _referrer='';
  bool _hasRef=false;

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
    var result=await http.post(Uri.parse('https://www.idehcharge.com/Middle/Api/Charge/Register'),body: {

      "CellNumber": _cellNumber,
      "DeviceKey": _devId,
      "Os": "$os_id",
      "Referral":_referrer


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
              CButton(label: '????????',onClick: ()=>Navigator.of(context).pop(),)
            ],
          ),
        );
      }

    }
    else {
      setState(() {
        _progressing=false;
        showDialog(context: context, builder: (context) => CAlertDialog(
          content: '???????? ???????? ${result.statusCode}',
          subContent: '?????? ???? ?????????????? ???????????? ???? ????????',
          buttons: [CButton(onClick: (){
            Navigator.of(context).pop();

          },
            label: '????????',
          )],
        ),);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return        Scaffold(
        body:       ModalProgressHUD(
          child:

          RegPageTemplate(
            children: [
              Text('???????? ???????? ???? ?????? ?????? ?????????? ?????????? ?????? ???? ???????? ????????',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,),
              CTextField(textAlign: TextAlign.center,controller: _mobile,maxLenght: 11,keyboardType: TextInputType.phone,),
              Padding(padding: EdgeInsets.only(top: 3)),
              CButton(onClick: (){
                if(_mobile.text.length==11 && _mobile.text.startsWith('09'))

                  showDialog(context: context,
                    builder: (context) {

                      return CAlertDialog(
                        content: '?????? ???? ?????? ?????????? ?????????? ???????? ?????? ?????????????? ????????????',
                        subContent: '${_mobile.text}',
                        buttons: [
                          CButton(onClick: (){Navigator.of(context).pop();},label: '????????????',minWidth: 120,),

                          CButton(onClick: (){
                            sendMobileNumber();



                            Navigator.of(context).pop();
                          },label: '??????????',minWidth: 120,),

                        ],
                      );
                    },
                  );
                else
                  showDialog(context: context,
                    builder: (context) => CAlertDialog(content:'??????',subContent: '?????????? ???????????? ???????? ?????? ???????? ????????',buttons: [CButton(label: '??????????',onClick: ()=>Navigator.of(context).pop(),)],),
                  );
              },label: '????????',minWidth: 120,),
              Padding(padding: EdgeInsets.only(top: 15)),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _hasRef=!_hasRef;
                  });
                },
                child:
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                      color: PColor.orangepartoAccent,
                      borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: PColor.blueparto,
                      blurRadius: 3,
                      offset: Offset(0,0),
                      spreadRadius: 1
                    )]


                  ),
                  child: _hasRef?Row(
                    children: [
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                            hintText: '?????????? ???????????? ????????',
                           // counter: ,
                            counterText: ''
                          //counter: Stage

                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                      )),
                      IconButton(icon: Icon(Icons.close,color: PColor.blueparto,), onPressed: (){setState(() {
                        _hasRef=!_hasRef;
                      });})
                    ],
                  ):

                  Text('???????? ????????',style: TextStyle(color: PColor.blueparto),textAlign: TextAlign.center,),
                )
                ,
              )

            ],
          ),
          inAsyncCall: _progressing, )

    )



    ;
  }


}
