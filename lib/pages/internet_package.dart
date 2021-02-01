import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/classes/convert.dart';
import 'package:parto_v/classes/global_variables.dart';
import 'package:parto_v/classes/internet_package.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/classes/wallet.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice_dialog.dart';
import 'package:parto_v/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:parto_v/custom_widgets/cust_seletable_grid_item.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:url_launcher/url_launcher.dart';

class InternetPackagePage extends StatefulWidget {
  @override
  _InternetPackagePageState createState() => _InternetPackagePageState();
}

class _InternetPackagePageState extends State<InternetPackagePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _mobile = new TextEditingController();
  int _topUpOperator = -1;
  bool _progressing = false;
  String _paymentLink = '';
  bool _canUseWallet = false;
  double _walletAmount = 0;
  bool _readyToPay = false;
  String _invoiceTitle = '';
  String _invoiceSubTitle = '';
  double _invoiceAmount = 0;

  bool _inprogress = false;
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

  //List of Internet Packages by duration
  Map<int,String>_packages= {0:'ساعتی',1:'روزانه',2: 'هفتگی',3:'ماهانه', 8:'دوماهه', 9:'سه ماهه',10:'چهارماهه',4:'شش ماهه', 5:'یکساله'};

  int _selectedPackage=-1;
  Widget Packages(){
    List<Widget> _list=[];
   _packages.forEach((key, value) {
     _list.add(CSelectedButton(
       value:key ,
       label: value,
       height: 35,
       selectedValue: _selectedPackage,
       onPress: (x){
         setState(() {
           _selectedPackage=x;
         });
       },

     ));
   });
   return ListView(
     padding: EdgeInsets.zero,
     children: _list,
   );
  }



// List of mobile operator with color and grayscale images
  List<InternetPackageOperators> _operatorsWithLogo = [
    new InternetPackageOperators(
        id: 0,
        name: 'ایرانسل',
        colorImage: 'assets/images/mtn-color.jpg',
        grayImage: 'assets/images/mtn-gray.jpg',
      simTypes: [
        new SimCardTypes(id: 0,name: 'دائمی'),
        new SimCardTypes(id: 1,name: 'اعتباری'),
        new SimCardTypes(id: 2,name: 'اعتباری TDLte'),
        new SimCardTypes(id: 4,name: 'دایمی FDLte')
      ]
),
    new InternetPackageOperators(
        id: 1,
        name: 'همراه اول',
        colorImage: 'assets/images/mci-color.jpg',
        grayImage: 'assets/images/mci-gray.jpg',
        simTypes: [
          new SimCardTypes(id: 0,name: 'دائمی'),
          new SimCardTypes(id: 1,name: 'اعتباری')
        ]),
    new InternetPackageOperators(
        id: 3,
        name: 'رایتل',
        colorImage: 'assets/images/rightel-color.jpg',
        grayImage: 'assets/images/rightel-gray.jpg',
        simTypes: [
          new SimCardTypes(id: 0,name: 'دائمی'),
          new SimCardTypes(id: 1,name: 'اعتباری'),
          new SimCardTypes(id: 3,name: 'دیتا')
        ]),
    new InternetPackageOperators(
        id: 4,
        name: 'شاتل موبایل',
        colorImage: 'assets/images/shatel-color.jpg',
        grayImage: 'assets/images/shatel-gray.jpg',
        simTypes: [
          new SimCardTypes(id: 1,name: 'اعتباری'),
        ]),
  ];

  //operator list for selection
  int _selectedOperator=-1;
  Widget Operators(){
    List<Widget> _list=[];
    var _x=_operatorsWithLogo;
    _x.forEach((e) {
      _list.add(CSelectedButton(
        value:e.id ,
        label: e.name,
        height: 35,
        selectedValue: _selectedOperator,
        onPress: (x){
          setState(() {
            _selectedOperator=x;
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


  // sim card row for every operator
  int _selectedSimCard=0;
  Widget SimCards(int selectedOprator) {
    List<Widget> _list = [];
    var _x = _operatorsWithLogo[selectedOprator];
    _x.simTypes.forEach((e) {
      _list.add(CSelectedButton(
        value:e.id ,
        label: e.name,
        height: 35,
        selectedValue: _selectedSimCard,
        onPress: (x){
          setState(() {
            _selectedSimCard=x;
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


  // for step of Stepper
  int _currentStep = 0;



//send to payment Api  *** most redefine
/*
  void _sendToPayment() {
    TopUp _current = new TopUp();
    _prefs.then((value) {
      _current.sign = value.getString('sign');
      _current.amount = _selectedAmount;
      _current.chargeType = _selectedTopUpType;
      _current.cellNumber = _mobile.text.substring(1, 11);
      _current.deviceId = 0;
      _current.useWallet = false;
      _current.localDate = DateTime.now();
      _current.topUpOperator = _topUpOperator;
      _current.uniqCode = "";
    }).then((value) {
      setState(() {
        _progressing = true;
      });

      _payChargeWithCardAndSend(_current).then((value) {});
    });
  }
*/




  Future<void> _payWithWallet() async {
    int _refIdIndex = _paymentLink.indexOf('?RefId=') + 7;
    String _refId = _paymentLink.substring(_refIdIndex);
    setState(() {
      _readyToPay = false;
      _progressing = true;
    });

    auth.checkAuth().then((value) async {
      if (value) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        String _token = _prefs.getString('token');
        var _body = {
          "ReferenceNumber": int.parse(_refId),
          "LocalDate": DateTime.now().toString(),
          "Sign": _prefs.getString('sign'),
          "UseWallet": true
        };
        var jBody = json.encode(_body);

        var result = await http.post(
            'https://www.idehcharge.com/Middle/Api/Charge/WalletApprove',
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json'
            },
            body: jBody);
        if (result.statusCode == 401) {
          auth.retryAuth().then((value) {
            _payWithWallet();
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
          if (jres["ResponseCode"] == 0)
            showDialog(
              context: context,
              builder: (context) => CAlertDialog(
                content: 'عملیات موفق',
                subContent: 'شارژ و پرداخت از کیف پول با موفقیت انجام شد',
                buttons: [
                  CButton(
                    label: 'بستن',
                    onClick: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );
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
  }

/*
  Widget _paymentDialog() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AnimatedPositioned(
          duration: Duration(seconds: 2),
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7 + 30,
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width - 30,
                    padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: PColor.blueparto,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                        boxShadow: [
*/
/*
                        BoxShadow(
                            color: PColor.orangeparto,
                            blurRadius: 3,
                            spreadRadius: 3,
                            offset: Offset(0,-1)
                        ),
*//*

                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                'تایید اطلاعات تراکنش',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textScaleFactor: 1.3,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'اطلاعات را مطالعه و پس از اطمینان پرداخت نمایید',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                                textScaleFactor: 0.8,
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                padding: EdgeInsets.all(12),
                                margin:
                                EdgeInsets.only(top: 5, left: 0, right: 0),
                                decoration: BoxDecoration(
                                  color: PColor.blueparto.shade900,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'نام محصول:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                          textScaleFactor: 1,
                                        ),
                                        Text(
                                          '${_invoiceTitle}',
                                          style: TextStyle(
                                              color: PColor.orangeparto,
                                              fontWeight: FontWeight.bold),
                                          textScaleFactor: 1,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'نوع محصول:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                          textScaleFactor: 1,
                                        ),
                                        Text(
                                          '${_invoiceSubTitle}',
                                          style: TextStyle(
                                              color: PColor.orangeparto,
                                              fontWeight: FontWeight.bold),
                                          textScaleFactor: 1,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'مبلغ پرداخت:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                          textScaleFactor: 1.2,
                                        ),
                                        Text(
                                          '${getMoneyByRial(_invoiceAmount.toInt())} ریال',
                                          style: TextStyle(
                                              color: PColor.orangeparto,
                                              fontWeight: FontWeight.bold),
                                          textScaleFactor: 1.2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'روش پرداخت',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textScaleFactor: 1.3,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'یکی از روش های پرداخت را انتخاب نمایید',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                                textScaleFactor: 0.8,
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                children: [
                                  CSelectedButton(
                                    label: 'کیف پول',
                                    height: 40,
                                    selectedColor: Colors.blue,
                                    selectedValue: _selectedPaymentType,
                                    value: 0,
                                    onPress: (v) {
                                      setState(() {
                                        _selectedPaymentType = v;
                                      });
                                    },
                                  ),
                                  CSelectedButton(
                                    label: 'کارت بانکی',
                                    selectedValue: _selectedPaymentType,
                                    selectedColor: Colors.blue,
                                    height: 40,
                                    value: 1,
                                    onPress: (v) {
                                      setState(() {
                                        _selectedPaymentType = v;
                                      });
                                    },
                                  )
                                ],
                              ),
                              _selectedPaymentType == 0
                                  ? Container(
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(
                                    top: 5, left: 0, right: 0),
                                decoration: BoxDecoration(
                                  color: PColor.blueparto.shade900,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'مانده کیف پول:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.normal),
                                          textScaleFactor: 1,
                                        ),
                                        Text(
                                          '${getMoneyByRial(_walletAmount.toInt())} ریال',
                                          style: TextStyle(
                                              color: PColor.orangeparto,
                                              fontWeight:
                                              FontWeight.bold),
                                          textScaleFactor: 1,
                                        ),
                                      ],
                                    ),
                                    _walletAmount < _invoiceAmount
                                        ? Text(
                                      'مبلغ ${getMoneyByRial(_invoiceAmount.toInt())} ریال با کارت بانکی پرداخت شود',
                                      style: TextStyle(
                                          color: PColor.orangeparto,
                                          fontWeight:
                                          FontWeight.normal),
                                      textScaleFactor: 1,
                                    )
                                        : Container(
                                      height: 0,
                                    ),
                                  ],
                                ),
                              )
                                  : Container(
                                height: 0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _selectedPaymentType == 0 &&
                                  _walletAmount > _invoiceAmount
                                  ? CButton(
                                label: 'پرداخت با کیف پول',
                                onClick: () {
                                  _payWithWallet();
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                              )
                                  : CButton(
                                label: 'پرداخت با درگاه بانکی',
                                onClick: () async {
                                  if (await canLaunch(_paymentLink))
                                    launch(_paymentLink).then((value) {
                                      setState(() {
                                        _readyToPay = false;
                                      });
                                    });
                                },
                                color: Colors.redAccent,
                                textColor: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'مبلغ قابل پرداخت',
                                    style: TextStyle(color: Colors.white70),
                                    textScaleFactor: 0.9,
                                  ),
                                  Text(
                                    ' ${getMoneyByRial(_invoiceAmount.toInt())} ریال',
                                    style: TextStyle(
                                        color: PColor.orangeparto,
                                        fontWeight: FontWeight.bold),
                                    textScaleFactor: 1.2,
                                  )
                                ],
                              )
                            ],
                          ),
                          //  color: Colors.red,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 10,
                      child: GestureDetector(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              color: PColor.orangeparto),
                          child: Icon(
                            Icons.close,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _readyToPay = false;
                          });
                        },
                      ))
                ],
              ),
            ),
          ),
          bottom: _readyToPay
              ? 0
              : (MediaQuery.of(context).size.height * 0.7 + 30) * -1,
          right: 5,
          left: 5,
          curve: Curves.fastLinearToSlowEaseIn,
        ));
  }
*/

//پایان ویجت پرداخت

/*
  Future<void> _payChargeWithCard(TopUp topUp) async {
    auth.checkAuth().then((value) async {
      if (value) {
        SharedPreferences _p = await SharedPreferences.getInstance();
        String _token = _p.getString('token');
        var jsonTopUp = topUpToJson(topUp);
        var result = await http.post(
            'https://www.idehcharge.com/Middle/Api/Charge/TopUp',
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json'
            },
            body: jsonTopUp);
        if (result.statusCode == 401) {
          auth.retryAuth().then((value) {
            _payChargeWithCard(topUp);
          });
        }
        if (result.statusCode == 200) {
          debugPrint(result.body);
          var jres = json.decode(result.body);
          setState(() {
            _progressing = false;
          });

          if (jres['ResponseCode'] == 0)
            showDialog(
              context: context,
              builder: (context) {
                return PreInvoice(
                  title:
                  '${_chargeTypes[_selectedChargeType]}  ${_operatorsWithLogo[_topUpOperator].name}',
                  subTitle:
                  '${_operatorsWithLogo[_topUpOperator].chargeTypes[_selectedTopUpType].name}',
                  amount: _selectedAmount.toDouble(),
                  canUseWallet: jres['CanUseWallet'],
                  paymentLink: jres['Url'],
                  walletAmount: 0,
                );
              },
            );
          else if (jres['ResponseCode'] == 5) {
            auth.retryAuth().then((value) {
              _payChargeWithCard(topUp);
            });
          } else
            showDialog(
              context: context,
              builder: (context) => CAlertDialog(
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
      } else
        showDialog(
          context: context,
          builder: (context) => CAlertDialog(
            content: 'خطا در احراز هویت',
            buttons: [
              CButton(
                label: 'بستن',
                onClick: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
    });
  }
*/

/*
  Future<void> _payChargeWithCardAndSend(TopUp topUp) async {
    auth.checkAuth().then((value) async {
      if (value) {
        try {
          SharedPreferences _p = await SharedPreferences.getInstance();
          String _token = _p.getString('token');
          var jsonTopUp = topUpToJson(topUp);
          var result = await http.post(
              'https://www.idehcharge.com/Middle/Api/Charge/TopUp',
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json'
              },
              body: jsonTopUp).timeout(Duration(seconds: 20));
          if (result.statusCode == 401) {
            auth.retryAuth().then((value) {
              _payChargeWithCard(topUp);
            });
          }
          if (result.statusCode == 200) {
            debugPrint(result.body);
            var jres = json.decode(result.body);
            setState(() {
              _progressing = false;
            });

            if (jres['ResponseCode'] == 0) {
              setState(() {
                _invoiceTitle =
                '${_chargeTypes[_selectedChargeType]}  ${_operatorsWithLogo[_topUpOperator]
                    .name}';
                _invoiceSubTitle =
                '${_operatorsWithLogo[_topUpOperator]
                    .chargeTypes[_selectedTopUpType].name}';
                _invoiceAmount = _selectedAmount.toDouble();
                _canUseWallet = jres['CanUseWallet'];
                _paymentLink = jres['Url'];
                _walletAmount = jres['Cash'];
                _readyToPay = true;
              });
            }

            else
              showDialog(
                context: context,
                builder: (context) =>
                    CAlertDialog(
                      content: 'خطای تراکنش',
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
        } on TimeoutException catch(e){
          setState(() {
            _progressing=false;
          });
          showDialog(
            context: context,
            builder: (context) =>
                CAlertDialog(
                  content: 'خطای ارتباط',
                  subContent: 'ارتباط با سرور برقرار نشد',
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
  }
*/






  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _inprogress,
        child: Stack(
          children: [
            MasterTemplateWithoutFooter(

              // inProgress: _inprogress,
                wchild: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      'بسته های اینترنت',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'اطلاعات مربوط به خرید بسته را وارد کنید',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      color: PColor.orangeparto,
                      thickness: 2,
                    ),
                    // بخش مربوط به اطلاعات اصلی
                    Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: PColor.orangeparto,
                                    width: 2,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(12),
                                color: PColor.orangepartoAccent,
                              ),
                              child:
                              Column(
                                children: [
                                  Text(
                                    'شماره همراه مورد نظر را وارد و یا از دفترچه تلفن انتخاب کنید',
                                    textScaleFactor: 0.9,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child:
                                          TextField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  gapPadding: 2,
                                                ),
                                                suffixIcon: Icon(
                                                  Icons.sim_card,
                                                  color: PColor.orangeparto,
                                                ),
                                                fillColor: Colors.white,
                                                counterText: '',
                                                hintText: 'مثال 09123456789'),
                                            keyboardType: TextInputType.phone,
                                            maxLength: 11,
                                            controller: _mobile,
                                            onChanged: (v) {
                                              if (v.isNotEmpty &&
                                                  v.length > 3 &&
                                                  v.startsWith('09')) {

                                                _onPhoneChange(v);
                                              } else {
                                                setState(() {
                                                  _selectedOperator = -1;
                                                });
                                              }
                                            },
                                            textAlign: TextAlign.center,
                                          )
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: PColor.blueparto,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.contact_page_rounded,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          getContact().then((value) {
                                            setState(() {
                                              _mobile.text = value;
                                              _onPhoneChange(value);
                                            });
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: PColor.orangeparto,
                                    indent: 5,
                                    endIndent: 5,
                                    thickness: 2,
                                  ),
                                  Text(
                                    'در صورت ترابرد خط، اپراتور را تغییر دهید',
                                    style: TextStyle(
                                        color: PColor.blueparto,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                  //بخش مربوط به گزینه های نوع شارژ تاپ آپ
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    height: 60,
                                    //لیست لوگو و آیکون اپراتورهای موبایل
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _operatorsWithLogo.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: index == _selectedOperator
                                                        ? PColor.blueparto
                                                        : Colors.grey,
                                                    width: 1),
                                                boxShadow: index == _selectedOperator
                                                    ? [
                                                  BoxShadow(
                                                      color:
                                                      PColor.blueparto,
                                                      offset: Offset(0, 0),
                                                      spreadRadius: 1,
                                                      blurRadius: 1)
                                                ]
                                                    : [
                                                  BoxShadow(
                                                      color: PColor
                                                          .orangeparto,
                                                      offset: Offset(0, 0),
                                                      spreadRadius: 0,
                                                      blurRadius: 0)
                                                ],
                                                image: DecorationImage(
                                                  image: AssetImage(index ==
                                                      _selectedOperator
                                                      ? _operatorsWithLogo[index]
                                                      .colorImage
                                                      : _operatorsWithLogo[index]
                                                      .grayImage),
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedOperator = index;
                                              _selectedSimCard=-1;

                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  //بخش نمایش گزینه های sim قابل انجام برای هر اپراتور
                                  _selectedOperator != -1
                                      ? Column(
                                    children: [
                                      Divider(
                                        color: PColor.orangeparto,
                                        indent: 5,
                                        endIndent: 5,
                                        thickness: 2,
                                      ),
                                      Text(
                                        'نوع سیم کارت را انتخاب کنید',
                                        style: TextStyle(
                                            color: PColor.blueparto,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
                                        textAlign: TextAlign.start,
                                      ),
                                      SimCards(_selectedOperator),
                                    ],
                                  )
                                      : Container(
                                    height: 0,
                                  ),
                                  // بخش نمایش مبالغ مربوط به گزینه تا آپ

                                ],
                              )

                            ),
                            Container(
                              height: 90,
                            ),
                          ],
                        )),
                  ],
                )),
            _progressing
                ? Progress()
                : Positioned(
              bottom: 0,
              left: 5,
              right: 5,
              child: Container(
                height: 90,
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
    if (_mobile.text.length<11) {
      showDialog(
          context: context,
          builder: (context) =>
              CAlertDialog(
                content: 'خطا در شماره',
                subContent:
                'شماره موبایل صحیح نیست',
                buttons: [
                  CButton(
                    label: 'بستن',
                    onClick: () =>
                        Navigator.of(context).pop(),
                  )
                ],
              ));
    }
                          else if (_selectedOperator == -1
                              ||_selectedSimCard ==-1
                              ) {
                            showDialog(
                                context: context,
                                builder: (context) => CAlertDialog(
                                  content: 'خطا در انتخاب اپراتور',
                                  subContent:
                                  'اطلاعات مربوط به اپراتور انتخاب نشده است',
                                  buttons: [
                                    CButton(
                                      label: 'بستن',
                                      onClick: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ));
                          }

                          else {
                           // _sendToPayment();
                          }
                        },
                        minWidth: 150,
                      ),

                      CButton(
                        label: 'تکرار خرید قبلی',
                        onClick: () {},
                        minWidth: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //_paymentDialog()
          ],
        ));
  }

  //Detect operator of mobile with 3 number of starting
  _onPhoneChange(String number) {
    if (number.length > 2) {
      var _firstCharacter = number.substring(0, 3);
      switch (_firstCharacter) {
        case '091':
          {
            setState(() {
              _selectedOperator = 1;
            });
            setState(() {});
          }
          break;
        case '093':
          {
            setState(() {
              _selectedOperator = 0;
            });
            setState(() {});
          }
          break;
        case '092':
          {
            setState(() {
              _selectedOperator = 2;
            });
            setState(() {});
          }
          break;
        case '099':
          {
            setState(() {
              _selectedOperator = 3;
            });
            setState(() {});
          }
          break;

        default:
          {
            setState(() {
              _selectedOperator = -1;
            });
          }
          break;
      }
    }
  }

  @override
  void dispose() {
    this.dispose();
  }

  Future<String> getContact() async {
    final ContactPicker _contactPicker = new ContactPicker();
    String _phoneNumber;
    Contact contact = await _contactPicker.selectContact();
    if (contact.phoneNumber != null) {
      _phoneNumber = contact.phoneNumber.number;
      _phoneNumber = _phoneNumber.replaceAll('+98', '0');
      _phoneNumber = _phoneNumber.replaceAll(' ', '');
      _phoneNumber = _phoneNumber.replaceAll('-', '');
      _phoneNumber = _phoneNumber.replaceAll('(', '');
      _phoneNumber = _phoneNumber.replaceAll(')', '');
    }
    return _phoneNumber;
  }
}
