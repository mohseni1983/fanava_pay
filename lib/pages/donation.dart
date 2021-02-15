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
  List<FinancingInfoList> _charities=[];

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








  @override
  void initState() {

    getListOfCharities();

    // TODO: implement initState
    super.initState();

  }

  Future<List<FinancingInfoList>> getListOfCharities() async {
    setState(() {
      //  _readyToPay = false;
      _progressing = true;
    });

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
          setState(() {
            _progressing = false;
          });

          await setWalletAmount();
          setState(() {

          });
          var jres = json.decode(result.body);
          debugPrint('==========================================================================');
          debugPrint(jres.toString());
          debugPrint('==========================================================================');

             if (jres["ResponseCode"] == 0)
             {
               var data=charitiesFromJson(result.body);


               return data.charityTerminals.financingInfoLists;
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
             return null;
        }
      }
    });

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
              return Column(

                children: [
                  Text(
                    'نیکوکاری',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: PColor.orangeparto,
                    thickness: 2,
                  ),

                  Expanded(child:
                  ListView.builder(
                    itemCount: item.length ,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, i) => CSelectedButton(
                      label: item[i].title,
                      value: item[i].pspId,
                      selectedValue: _selectedCharity,
                      onPress: (t){
                        setState(() {
                          _selectedCharity=t;
                          _charityTerminalId=item.firstWhere((element) => element.pspId==t).termId;
                        });
                      },
                    ),
                  )
                  )
                ],
              );

            }
        }
        break;
        }

      return Container(height: 0,);
    },);

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
                    //    Padding(padding: EdgeInsets.only(top: 5)),
                    CharityList()


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
