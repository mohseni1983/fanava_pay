import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/pages//main_page.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:parto_v/custom_widgets/cust_textfield.dart';
import 'package:parto_v/components/reg_page_template.dart';
class EnterOTP extends StatefulWidget {
  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  String _phoneNumber='';
  String _deviceId='';
  int _OS_id=0;
  TextEditingController _otp=new TextEditingController();
   Timer _timer;
  int _start = 60;
  bool _progress=false;

  void startTimer() {

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _prefs.then((value) {
      setState(() {
        _phoneNumber=value.getString('username');
        _deviceId=value.getString('device_id');
        _OS_id=value.getInt('os');
      });
      startTimer();
    });
  }


  @override
  Widget build(BuildContext context) {

    return
    ModalProgressHUD(inAsyncCall: _progress,

        child:       RegPageTemplate(
          children: [
            Text('کد ارسالی به شماره زیر را وارد کنید',style: Theme.of(context).textTheme.caption,textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('0$_phoneNumber  ',textScaleFactor: 1.3,style: Theme.of(context).textTheme.caption,),
                GestureDetector(
                  onTap: ()=>Navigator.of(context).pop(),
                  child: Text('ویرایش',style: TextStyle(color: PColor.orangeparto),),
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
              label: 'ورود',
              onClick: (){
                _registerOTP();

              },
            ),
            Padding(padding: EdgeInsets.only(top: 15)),

            _timer.tick!=null?_timer.tick<60 ?
            CircleAvatar(
              radius: 25,
              child:             Text('${60-_timer.tick}',style: TextStyle(color: PColor.blueparto,fontWeight: FontWeight.bold),textScaleFactor: 1.1,textAlign: TextAlign.center,)
              ,
            ):
            GestureDetector(
                onTap: (){sendMobileNumber();},
                child:
                Text('ارسال مجدد کد',style: TextStyle(color: PColor.orangeparto),textScaleFactor: 1.1,textAlign: TextAlign.center,)

            ):
            Container(height: 0,)


          ],
        )
    )

    ;
    ;
  }



  Future<void> sendMobileNumber() async {
    var result=await http.post('https://www.idehcharge.com/Middle/Api/Charge/Register',body: {

      "CellNumber": _phoneNumber,
      "DeviceKey": _deviceId,
      "Os": "$_OS_id"


    });
    if(result.statusCode==200){
        //debugPrint('Sended');
      startTimer();
      }

    }

  Future<void> _registerOTP() async {
    setState(() {
      _progress=true;
    });
    String _usename='';
    String _device_id='';
    int os_id=0;
    _prefs.then((value) {
      setState(() {
        _usename=value.getString('username');
        _device_id=value.getString('device_id');
        os_id=value.getInt('os');

      });
    }).then((value) async {
      var result=await http.post('https://www.idehcharge.com/Middle/Api/Charge/Active',body: {
        "CellNumber": _usename,
        "DeviceKey": _device_id,
        "Os": os_id.toString(),
        "RegisterCode":_otp.text
      });
      if(result.statusCode==200){
        var res=json.decode(result.body);
        if(res['ResponseCode']==0)
        _prefs.then((value) {
          var _body=json.decode(result.body);
          value.setString('password', _device_id);
          value.setString('sign',_body['SignKey'] );
        }).then((value) async{
          var token_result=await http.post('https://www.idehcharge.com/Middle/Api/Charge/Login',
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
                content: 'خطا در ورود به سیستم',
                buttons: [CButton(label: 'قبول',onClick: ()=>Navigator.of(context).pop(),)],
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
            buttons: [CButton(label: 'قبول',onClick: ()=>Navigator.of(context).pop(),)],
          ) ,
          );}
      }else{
        debugPrint(result.statusCode.toString());
        debugPrint(result.body);
      }

    });
  }


  }


