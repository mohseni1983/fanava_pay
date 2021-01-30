import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/classes/convert.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice.dart';
import 'package:parto_v/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:parto_v/custom_widgets/cust_seletable_grid_item.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:url_launcher/url_launcher.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _progressing=false;


  //پروگرس ارتباط با سرور جهت دریافت اطلاعات
  Widget Progress()=>
      Material(
        color: Colors.transparent,
        child:    Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: PColor.orangeparto.withOpacity(0.8),
          child: Center(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(height: 30,width: 30,child: CircularProgressIndicator(),),
                Text('در حال دریافت اطلاعات',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),textScaleFactor: 1.4,)
              ],
            ),
          ),
        ),

      );




  // for step of Stepper
  int _currentStep = 0;

  bool _inprogress = false;







  Future<void> _payWalletCharge() async {
    setState(() {
      _progressing=true;
    });
    auth.checkAuth().then((value) async {
      if (value) {
        SharedPreferences _p = await SharedPreferences.getInstance();
        String _token = _p.getString('token');
        var _body=
          {
            "Amount": _selectAmountForCharge,
            "LocalDate": DateTime.now().toString(),
            "Sign": _p.getString('sign'),
            "UseWallet": true
          };
        var jBody=json.encode(_body);
        var result = await http.post(
            'https://www.idehcharge.com/Middle/Api/Charge/Wallet',
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json'
            },
            body: jBody);
        if (result.statusCode == 401) {
          auth.retryAuth().then((value) {
            _payWalletCharge();
          });
        }
        if (result.statusCode == 200) {
          setState(() {
            _progressing=false;
          });
          debugPrint(result.body);
          var jres = json.decode(result.body);

          if (jres['ResponseCode'] == 0)
          {
            if(await canLaunch(jres['Url']))
              await launch(jres['Url']);

          }else{
            showDialog(context: context,
            builder: (context) => CAlertDialog(
              content: 'خطا در عملیات',
              subContent: jres['ResponseMessage'],
              buttons: [CButton(
                label: 'بستن',
                onClick: ()=>Navigator.of(context).pop(),
              )],
            ),
            );
          }




        }
      }

    });
  }




//ویجت مربوط به انتخاب عملیات کیف پول
  List<String> _walletOperationTypeList=['شارژ کیف پول','گزارش تراکنش ها'];
  int _selectedWalletOperation=0;
  Widget WalletOperationTypes() {
    List<Widget> _list = [];
    var _x = _walletOperationTypeList.asMap();
    _x.forEach((key, v) {
      _list.add(CSelectedButton(
        value: key,
        label: v,
        height: 40,
        selectedValue: _selectedWalletOperation,
        onPress: (x) {
          setState(() {
            _selectedWalletOperation = x;
          });
        },
      ));
    });

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _list,
    );
  }
//ویجت مربوط به انتخاب عملیات کیف پول-پایان

  //ویجت عدد اعتبار
  int _selectAmountForCharge=500000;
  List<int> _predefinedAmountList=[100000,500000,750000,1000000];
  Widget ChargeAmountSelector(){
    return
        Container(
          margin: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: PColor.orangeparto,
            borderRadius: BorderRadius.circular(10)
          ),
          child:
          Row(
            children: [
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: PColor.blueparto,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(10))
                  ),
                  width: 80,
                  height: 50,
                  
                  child: Center(
                    child: Icon(Icons.add,size: 35,color: Colors.white,),
                  ),
                ),
                onTap: (){
                  if(_selectAmountForCharge<500000000)
                    setState(() {
                      _selectAmountForCharge=_selectAmountForCharge+10000;
                    });
                },

              ),
              Expanded(child: Container(
                  color: PColor.orangepartoAccent,
                  height: 50,
                  child: Center(
                    child: Text('${getMoneyByRial(_selectAmountForCharge)} ریال',style: TextStyle(color: PColor.blueparto,fontWeight: FontWeight.bold),textScaleFactor: 1.5,),
                  )
              )),
              GestureDetector(
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                      color: PColor.blueparto,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
                  ),
                  child: Center(
                    child: Icon(Icons.remove,size: 35,color: Colors.white,),
                  ),
                ),
                onTap: (){
                  if(_selectAmountForCharge>=60000)
                    setState(() {
                      _selectAmountForCharge=_selectAmountForCharge-10000;
                    });
                },
              ),

            ],
          )

        );
  }
  Widget PreDefinedAmountSelector(){
    var _list=_predefinedAmountList.asMap();
    List<Widget> _widgetList=[];
    _list.forEach((key, value) {
      _widgetList.add(CSelectedButton(
        height: 40,
        label: getMoneyByRial(value),
        value: value,
        selectedValue: _selectAmountForCharge,
        onPress: (v){
          setState(() {
            _selectAmountForCharge=v;
          });
        },
      ));
    });
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: _widgetList,
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
          MasterTemplateWithoutFooter(

            // inProgress: _inprogress,
              wchild: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Text(
                    'مدیریت کیف پول',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'عملیات و گزارشات کیف پول',
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
                  // بخش مربوط به اطلاعات اصلی
                  Expanded(child:
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: PColor.orangeparto,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Text('عملیات مورد نظر را انخاب کنید',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            Divider(color: PColor.orangeparto,
                              indent: 5,
                              endIndent: 5,
                              thickness: 2,),
                            WalletOperationTypes(),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: PColor.orangeparto,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                          color: PColor.orangepartoAccent,
                        ),

                        child:
                        _selectedWalletOperation == 0 ?
                        //بخش مربوط به تاپ آپ
                        Column(
                          children: [
                            Text(
                              'مبلغ شارژ مد نظر برای کیف پول را انتخاب کنید',
                              textScaleFactor: 0.9,
                            ),
                            ChargeAmountSelector(),
                            PreDefinedAmountSelector()



                          ],
                        ) :
                        //بخش مربوط به کارت شارژ
                        Column(
                          children: [
                            Text(
                              'این بخش بزودی فعال می گردد',
                              style: TextStyle(
                                  color: PColor.blueparto,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                              textAlign: TextAlign.start,
                            ),

                          ],
                        ),


                      ),
                      Container(height: 90,
                      ),

                    ],
                  )),


                ],
              )

          ),
          _progressing?
          Progress():
              _selectedWalletOperation==0?
          Positioned(
            bottom: 0,
            left: 5,
            right: 5,

            child: Container(height: 90,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: PColor.orangeparto,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                        color: PColor.blueparto.shade300,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, -1)
                    )
                  ]
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CButton(label: 'پرداخت',
                      onClick: () {
                      _payWalletCharge();
                      },
                      minWidth: 150,),

                  ],
                ),
              ),
            ),
          ):Container(height: 0,),

        ],
      );

  }



  @override
  void dispose() {
    this.dispose();
  }


  Future<String> getContact() async{
    final ContactPicker _contactPicker = new ContactPicker();
    String _phoneNumber;
    Contact contact = await _contactPicker.selectContact();
    if(contact.phoneNumber!=null){
      _phoneNumber=contact.phoneNumber.number;
      _phoneNumber=_phoneNumber.replaceAll('+98', '0');
      _phoneNumber=_phoneNumber.replaceAll(' ', '');
      _phoneNumber=_phoneNumber.replaceAll('-', '');
      _phoneNumber=_phoneNumber.replaceAll('(', '');
      _phoneNumber=_phoneNumber.replaceAll(')', '');
    }
    return _phoneNumber;
  }

}

