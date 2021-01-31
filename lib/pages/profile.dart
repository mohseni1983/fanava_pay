import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parto_v/classes/profile.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<ProfileInfo> getProfile() async{
    auth.checkAuth().then((value) async{
      if (value) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        String _sign = _prefs.getString('sign');
        String _token = _prefs.get('token');
        var _body={
          "LocalDate": DateTime.now().toString(),
          "Sign": _sign,
          "UseWallet": true
        };
        var _jBody=json.encode(_body);
        var result = await http.post(
            'https://www.idehcharge.com/Middle/Api/Charge/GetOwnerInfo',
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json'
            },
            body: _jBody
        );
        if (result.statusCode==401)
        {
          auth.retryAuth().then((value) {
            getProfile();
          });
        }
        if(result.statusCode==200){
          debugPrint(result.body);
          var jres=json.decode(result.body);
          if(jres['ResponseCode']==0){
            var x=profileInfoFromJson(result.body);
            return x;



          }

        }
      }
    });
    return null;


  }
  ProfileInfo _info=new ProfileInfo();
  bool _getingData=true;
  bool _hasError=true;
  @override
  void initState() {
    getProfile().then((value) {
      if(value!=null)
      {
        setState(() {
          _info=value;
          _hasError=false;

        });


      }
      setState(() {
        _getingData=false;
      });



    });
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MasterTemplate(
      wchild:
        _getingData?
            Center(
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),

            ):
            _hasError?
                Center(
                  child: Container(
                    height: 30,
                    child: Text('خطا در دریافت اطلاعات از سرور'),
                  ),
                ):
            Column(

              children: [
                Padding(padding: EdgeInsets.only(top: 15)),
                CircleAvatar(
                  minRadius: 30,
                  maxRadius: 40,
                  backgroundColor: PColor.orangeparto,
                  child: Icon(Icons.person_outline_rounded,color: Colors.white,size: 45,),
                ),
                Text(
                  '${_info.deviceInfo.name} ${_info.deviceInfo.family}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'اطلاعات پروفایل کاربری',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: PColor.orangeparto,
                  thickness: 2,
                ),
                Expanded(child: ListView(
                  children: [
                    Row(
                      children: [
                        Text('شماره تلفن همراه',style: TextStyle(color: PColor.blueparto),),
                        Text('${_info.deviceInfo.cellNumber}',style: TextStyle(color: PColor.orangeparto,fontWeight: FontWeight.bold),)
                      ],
                    )
                  ],
                ))
              ],
            )





    );
  }
}
