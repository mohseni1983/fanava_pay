import 'dart:async';
import 'dart:convert';
import 'package:fanava_payment/classes/global_variables.dart' as globalVars;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:otp_count_down/otp_count_down.dart';
import 'package:fanava_payment/pages//main_page.dart';
import 'package:fanava_payment/custom_widgets/cust_alert_dialog.dart';
import 'package:fanava_payment/custom_widgets/cust_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanava_payment/ui/cust_colors.dart';
import 'package:fanava_payment/custom_widgets/cust_textfield.dart';
import 'package:fanava_payment/components/reg_page_template.dart';

import '../push_notifications.dart';
class EnterOTP extends StatefulWidget {
  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  String _phoneNumber='';
  String _deviceId='';
  int _OS_id=0;
 // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 // final pushNotificationService = PushNotificationService(_firebaseMessaging);




  TextEditingController _otp=new TextEditingController();
  bool _progress=false;
  bool _countEnded=false;
  String _fdm='';

  String _countDown='';
  OTPCountDown _otpCountDown;
  final int _otpTimeInMS = 1000 * 60;

  void _startCountDown() {
    setState(() {
      _countEnded=false;
    });
    _otpCountDown = OTPCountDown.startOTPTimer(
      timeInMS: _otpTimeInMS,

      currentCountDown: (String countDown) {
        _countDown = countDown;
        setState(() {});
      },
      onFinish: () {
       setState(() {
         _countEnded=true;
       });
      },
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    _otpCountDown.cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
/*
    pushNotificationService.initialise().then((value) {
      setState(() {
        _fdm=value;
      });
    });
*/

    _prefs.then((value) {
      setState(() {
        _phoneNumber=value.getString('username');
        _deviceId=value.getString('device_id');
        _OS_id=value.getInt('os');
      });
      _startCountDown();

    });
  }


  @override
  Widget build(BuildContext context) {

    return
    Scaffold(
      body:       ModalProgressHUD(inAsyncCall: _progress,

          child:       RegPageTemplate(
            children: [
              Text('???? ???????????? ???? ?????????? ?????? ???? ???????? ????????',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('0$_phoneNumber  ',textScaleFactor: 1.3,style: Theme.of(context).textTheme.caption,),
                  GestureDetector(
                    onTap: ()=>Navigator.of(context).pop(),
                    child: Text('????????????',style: TextStyle(color: PColor.orangeparto),),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 4)),
              CTextField(
                keyboardType: TextInputType.number,
                maxLenght: 5,
                textAlign: TextAlign.center,
                controller: _otp,

              ),
              CButton(
                minWidth: MediaQuery.of(context).size.width,
                label: '????????',
                onClick: (){
                  _registerOTP();

                },
              ),
              Padding(padding: EdgeInsets.only(top: 15)),

              !_countEnded ?
              CircleAvatar(
                radius: 25,
                child:             Text('$_countDown',style: TextStyle(color: PColor.blueparto,fontWeight: FontWeight.bold),textScaleFactor: 1.1,textAlign: TextAlign.center,)
                ,
              ):
              GestureDetector(
                  onTap: (){sendMobileNumber();},
                  child:
                  Text('?????????? ???????? ????',style: TextStyle(color: PColor.orangeparto),textScaleFactor: 1.1,textAlign: TextAlign.center,)

              )

            ],
          )
      )
      ,
    )


    ;

  }



  Future<void> sendMobileNumber() async {
    var result=await http.post(Uri.parse('https://www.idehcharge.com/Middle/Api/Charge/Register'),body: {

      "CellNumber": _phoneNumber,
      "DeviceKey": _deviceId,
      "Os": "$_OS_id"


    });
    if(result.statusCode==200){
        //debugPrint('Sended');
      _startCountDown();
      }

    }

  Future<void> _registerOTP() async {
    setState(() {
      _progress=true;
    });
    String _usename='';
    String _device_id='';
    int os_id=0;
    String _fcmKey='';



    _prefs.then((value) {
      setState(() {
        _usename=value.getString('username');
        _device_id=value.getString('device_id');
        os_id=value.getInt('os');
        _fcmKey=value.getString('fcmKey');

      });
    }).then((value) async {
      var result=await http.post(Uri.parse('https://www.idehcharge.com/Middle/Api/Charge/Active'),body: {
        "CellNumber": _usename,
        "DeviceKey": _device_id,
        "Os": os_id.toString(),
        "RegisterCode":_otp.text,
        "FcmKey": _fcmKey

      });
      if(result.statusCode==200){
        var res=json.decode(result.body);
        if(res['ResponseCode']==0)
        _prefs.then((value) {
          var _body=json.decode(result.body);
          value.setString('password', _device_id);
          value.setString('sign',_body['SignKey'] );
        }).then((value) async{
          var token_result=await http.post(Uri.parse('https://www.idehcharge.com/Middle/Api/Charge/Login'),
            body: {
              'username':'$_usename',
              'password':'$_device_id',
              'grant_type':'password'
            },

          );
          if(token_result.statusCode==200){
            var tres=json.decode(token_result.body);
            _prefs.then((value) {
              value.setString('token', tres['access_token']);
              String _expTime=DateTime.now().add(Duration(seconds:tres['expires_in'] )).toString();
              value.setString('time',_expTime );
              value.setString('refresh_token', tres['refresh_token']);
            }).then((value) {
              setState(() {
                _progress=false;
              });

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(),));});
          }else{
            setState(() {
              _progress=false;
            });

            showDialog(context: context,
              builder: (context) => CAlertDialog(
                content: '?????? ???? ???????? ???? ??????????',
                buttons: [CButton(label: '????????',onClick: ()=>Navigator.of(context).pop(),)],
              ) ,
            );
          }
        });
        else{
          setState(() {
            _progress=false;
          });

          showDialog(context: context,
          builder: (context) => CAlertDialog(
            content: res['ResponseMessage'],
            buttons: [CButton(label: '????????',onClick: ()=>Navigator.of(context).pop(),)],
          ) ,
          );}
      }else{
        debugPrint(result.statusCode.toString());
        debugPrint(result.body);
      }

    });
  }


  }


