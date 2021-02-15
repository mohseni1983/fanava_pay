import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan_fork/barcode_scan_fork.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parto_v/classes/charities.dart';
import 'package:parto_v/classes/wallet.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:parto_v/custom_widgets/cust_selectable_image_grid_btn.dart';
import 'package:parto_v/custom_widgets/cust_seletable_grid_item.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  bool _progressing = false;
  bool _isSetAmountPage=false;

  Widget Progress() => Material(
    color: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: PColor.orangeparto.withOpacity(0.8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
            Text(
              'در حال دریافت اطلاعات',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 1.4,
            )
          ],
        ),
      ),
    ),
  );

  Future<List<FinancingInfoList>> getListOfCharities() async {
    List<FinancingInfoList> _list=[];
    auth.checkAuth().then((value) async {
      if (value) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        String _token = _prefs.getString('token');
        var _body = {
          "LocalDate": DateTime.now().toString(),
          "Sign": _prefs.getString('sign'),
          "UseWallet": true
        };
        var jBody = json.encode(_body);

        var result = await http.post(
            'https://www.idehcharge.com/Middle/Api/Charge/GetCharityInfo',
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json'
            },
            body: jBody);
        if (result.statusCode == 401) {
          auth.retryAuth().then((value) {
            getListOfCharities();
          });
        }
        if (result.statusCode == 200) {

          var jres = json.decode(result.body);
             if (jres["ResponseCode"] == 0)
             {
               var data=charitiesFromJson(result.body);
                _list=data.charityTerminals.financingInfoLists;


             }
             else
               showDialog(
                 context: context,
                 builder: (context) => CAlertDialog(
                   content: 'عملیات ناموفق',
                   subContent: jres['ResponseMessage'],
                   buttons: [
                     CButton(
                       label: 'بستن',
                       onClick: () => Navigator.of(context).pop(),
                     )
                   ],
                 ),
               );

        }
      }
    });
    return  _list;

  }
  int _selectedCharity=-1;
  String _charityTerminalId='';
  Widget CharityList(){
    return
      FutureBuilder<List<FinancingInfoList>>(
      future: getListOfCharities(),
      builder: (context, snapshot) {
      switch(snapshot.connectionState){
        case ConnectionState.done:{


          if(snapshot.hasData)
            {
              var item=snapshot.data;
              return ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  var i=item[index];


                   return CSelectedButton(
                  label: i.title,
                     value: i.pspId,
                     selectedValue: _selectedCharity,
                     onPress: (t){
                    setState(() {
                      _selectedCharity=t;
                      _charityTerminalId=i.termId;
                    });
                     },
                );}
              );

            }
        }
        break;
        case ConnectionState.waiting:
        case ConnectionState.none:
        case ConnectionState.active:
          return Center(child: Text('test'),);
        }

      return Container(height: 0,);
    },)
    ;

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Stack(
          children: [
            MasterTemplateWithoutFooter(

              // inProgress: _inprogress,
                wchild: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text('dfgdfgdfgdfgdfgdfgdg'),
                    Text('dfgdfgdfgdfgdfgdfgdg'),
                    Text('dfgdfgdfgdfgdfgdfgdg'),

                    //    Padding(padding: EdgeInsets.only(top: 5)),
                    Expanded(child:
                    FutureBuilder<List<FinancingInfoList>>(
                      future: getListOfCharities(),
                      builder: (context, snapshot) {
                        switch(snapshot.connectionState){
                          case ConnectionState.done:{


                            if(snapshot.hasData)
                            {
                              var item=snapshot.data;
                              return ListView.builder(
                                  itemCount: item.length,
                                  itemBuilder: (context, index) {
                                    var i=item[index];


                                    return CSelectedButton(
                                      label: i.title,
                                      value: i.pspId,
                                      selectedValue: _selectedCharity,
                                      onPress: (t){
                                        setState(() {
                                          _selectedCharity=t;
                                          _charityTerminalId=i.termId;
                                        });
                                      },
                                    );}
                              );

                            }
                          }
                          break;
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                          case ConnectionState.active:
                            return Center(child: Text('test'),);
                        }

                        return Container(height: 0,);
                      },)


                    )


                    // بخش مربوط به اطلاعات اصلی
                  ],
                )),
            _progressing
                ? Progress()
                : Positioned(
              bottom: 0,
              left: 5,
              right: 5,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: PColor.orangeparto,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                          color: PColor.blueparto.shade300,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, -1))
                    ]),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CButton(
                        label: 'بعدی',
                        onClick: () {


                          //    _sendToPayment();

                        },
                        minWidth: 120,
                      ),
                      CButton(
                        label: 'قبلی',
                        onClick: () {

                        },
                        minWidth: 120,
                      )

                    ],
                  ),
                ),
              ),
            ),
            // _paymentDialog()
          ],
        )

    );
  }

}
