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
import 'package:parto_v/custom_widgets/cust_pre_invoice_dialog.dart';
import 'package:parto_v/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:parto_v/custom_widgets/cust_seletable_grid_item.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:url_launcher/url_launcher.dart';

class ChargeWizardPage extends StatefulWidget {
  @override
  _ChargeWizardPageState createState() => _ChargeWizardPageState();
}

class _ChargeWizardPageState extends State<ChargeWizardPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _mobile = new TextEditingController();
  int _topUpOperator = -1;
  bool _progressing=false;
  String _paymentLink='';
  bool _canUseWallet=false;
  double _walletAmount=0;
  bool _readyToPay=false;
  String _invoiceTitle='';
  String _invoiceSubTitle='';
  double _invoiceAmount=0;

  Widget Progress()=>
  Scaffold(
    body:       Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: PColor.orangeparto.shade300.withOpacity(0.5),
      child: Center(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(height: 30,width: 30,child: CircularProgressIndicator(),),
            Text('در حال دریافت اطلاعات')
          ],
        ),
      ),
    ),
  );



// List of mobile operator with color and grayscale images
  List<StraightChargeOperators> _operatorsWithLogo = [
    new StraightChargeOperators(
        id: 0,
        name: 'ایرانسل',
        colorImage: 'assets/images/mtn-color.jpg',
        grayImage: 'assets/images/mtn-gray.jpg',
        chargeTypes: [
          new ChargeTypesWithPrice(
              id: 0,
              name: 'معمولی',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000]),
          new ChargeTypesWithPrice(
              id: 1,
              name: 'شگفت انگیز',
              coverImage: '',
              prices: [50000, 100000, 200000])
        ]),
    new StraightChargeOperators(
        id: 1,
        name: 'همراه اول',
        colorImage: 'assets/images/mci-color.jpg',
        grayImage: 'assets/images/mci-gray.jpg',
        chargeTypes: [
          new ChargeTypesWithPrice(
              id: 0,
              name: 'معمولی',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000]),
          new ChargeTypesWithPrice(
              id: 2,
              name: 'بانوان',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000]),
          new ChargeTypesWithPrice(
              id: 3,
              name: 'جوانان',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000])
        ]),
    new StraightChargeOperators(
        id: 3,
        name: 'رایتل',
        colorImage: 'assets/images/rightel-color.jpg',
        grayImage: 'assets/images/rightel-gray.jpg',
        chargeTypes: [
          new ChargeTypesWithPrice(
              id: 0,
              name: 'معمولی',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000]),
          new ChargeTypesWithPrice(
              id: 1,
              name: 'شورانگیز',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000]),

        ]),
    new StraightChargeOperators(
        id: 4,
        name: 'شاتل موبایل',
        colorImage: 'assets/images/shatel-color.jpg',
        grayImage: 'assets/images/shatel-gray.jpg',
        chargeTypes: [
          new ChargeTypesWithPrice(
              id: 0,
              name: 'معمولی',
              coverImage: '',
              prices: [10000, 20000, 50000, 100000, 200000])
        ])
  ];

  // for step of Stepper
  int _currentStep = 0;

  bool _inprogress = false;

//send to payment Api  *** most redefine
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

      _payChargeWithCardAndSend(_current).then((value) {

      });
    });
  }

// List of master method of charging credit [مستقیم , کارت شارژ]
  List<String> _chargeTypes = ['شارژ مستقیم', 'کارت شارژ'];

  int _selectedAmount = 0;
  int _selectedChargeType = 0;
  int _selectedTopUpType = 0;


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
            _progressing=false;
          });

          if (jres['ResponseCode'] == 0)
            showDialog(context: context,
              builder: (context) {
                return PreInvoice(
                  title: '${_chargeTypes[_selectedChargeType] }  ${_operatorsWithLogo[_topUpOperator]
                      .name}',
                  subTitle: '${_operatorsWithLogo[_topUpOperator]
                      .chargeTypes[_selectedTopUpType].name}',
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
          }
          else
            showDialog(context: context,
              builder: (context) =>
                  CAlertDialog(
                    content: jres['ResponseMessage'],
                    buttons: [
                      CButton(label: 'بستن',
                        onClick: () => Navigator.of(context).pop(),)
                    ],
                  ),
            );
        }
      } else
        showDialog(context: context,
          builder: (context) =>
              CAlertDialog(
                content: 'خطا در احراز هویت',
                buttons: [
                  CButton(
                    label: 'بستن', onClick: () => Navigator.of(context).pop(),)
                ],
              ),
        );
    });
  }
  Future<void> _payChargeWithCardAndSend(TopUp topUp) async {
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
            _progressing=false;
          });

          if (jres['ResponseCode'] == 0)
            {
              setState(() {
                _invoiceTitle= '${_chargeTypes[_selectedChargeType] }  ${_operatorsWithLogo[_topUpOperator].name}';
                _invoiceSubTitle='${_operatorsWithLogo[_topUpOperator].chargeTypes[_selectedTopUpType].name}';
                _invoiceAmount=_selectedAmount.toDouble();
                _canUseWallet= jres['CanUseWallet'];
                _paymentLink=jres['Url'];
                _walletAmount=jres['Cash'];
                _readyToPay=true;

              });
            }
/*            showDialog(context: context,
              builder: (context) {
                return PreInvoice(
                  title: '${_chargeTypes[_selectedChargeType] }  ${_operatorsWithLogo[_topUpOperator]
                      .name}',
                  subTitle: '${_operatorsWithLogo[_topUpOperator]
                      .chargeTypes[_selectedTopUpType].name}',
                  amount: _selectedAmount.toDouble(),
                  canUseWallet: jres['CanUseWallet'],
                  paymentLink: jres['Url'],
                  walletAmount: 0,

                );
              },

            );*/
          else if (jres['ResponseCode'] == 5) {
            auth.retryAuth().then((value) {
              _payChargeWithCard(topUp);
            });
          }
          else
            showDialog(context: context,
              builder: (context) =>
                  CAlertDialog(
                    content: jres['ResponseMessage'],
                    buttons: [
                      CButton(label: 'بستن',
                        onClick: () => Navigator.of(context).pop(),)
                    ],
                  ),
            );
        }
      } else
        showDialog(context: context,
          builder: (context) =>
              CAlertDialog(
                content: 'خطا در احراز هویت',
                buttons: [
                  CButton(
                    label: 'بستن', onClick: () => Navigator.of(context).pop(),)
                ],
              ),
        );
    });
  }


  Widget SinglePrices = Container(height: 0,);

  Widget Prices(int OperatorId, int TopUpId) {
    List<Widget> _widgets = [];
    if (OperatorId != -1 && TopUpId != -1) {
      var _list = _operatorsWithLogo[OperatorId].chargeTypes[TopUpId].prices;
      var _x = _list.asMap();
      _x.forEach((key, value) {
        _widgets.add(
/*            CSelectedButton(
          height: 40,
          label: getMoneyByRial(value),
          selectedValue: _selectedAmount,
          onPress: (v) {
            setState(() {
              _selectedAmount = value;
            });
          },
          value: value,

        )*/
        CSelectedGridItem(
          height: 40,
          label: getMoneyByRial(value),
          selectedValue: _selectedAmount,
          onPress: (v) {
            setState(() {
              _selectedAmount = value;
            });
          },
          value: value,
        )
        );
      });
    }
    return GridView.count(
      mainAxisSpacing: 2,
      crossAxisCount: 3,
      childAspectRatio: 3,
      children: _widgets,
      padding: EdgeInsets.zero,
      shrinkWrap: true,

    );
  }

  Widget ChargeTypes() {
    List<Widget> _list = [];
    var _x = _chargeTypes.asMap();
    _x.forEach((key, v) {
      _list.add(CSelectedButton(
        value: key,
        label: v,
        height: 40,
        selectedValue: _selectedChargeType,
        onPress: (x) {
          setState(() {
            _selectedChargeType = x;
            _topUpOperator = 0;
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


  Widget TopUpChargeTypes(int OperatorId) {
    List<Widget> _wlist = [];
    if (OperatorId != -1) {
      var _list = _operatorsWithLogo[OperatorId].chargeTypes;
      var _mapedList = _list.asMap();
      _mapedList.forEach((key, value) {
        _wlist.add(CSelectedButton(
          height: 40,
          label: value.name,
          value: key,
          selectedValue: _selectedTopUpType,
          onPress: (t) {
            setState(() {
              _selectedTopUpType = t;
            });
          },

        ));
      });
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: _wlist,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(inAsyncCall: _inprogress,
        child: Stack(
          children: [
            MasterTemplateWithoutFooter(

              // inProgress: _inprogress,
                wchild: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      'شارژ تلفن همراه',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'اطلاعات مربوط به خرید شارژ را وارد کنید',
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
                              Text('نوع خرید شارژ را مشخص کنید',
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              Divider(color: PColor.orangeparto,
                                indent: 5,
                                endIndent: 5,
                                thickness: 2,),
                              ChargeTypes(),
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
                          _selectedChargeType == 0 ?
                          //بخش مربوط به تاپ آپ
                          Column(
                            children: [
                              Text(
                                'شماره همراه مورد نظر را وارد و یا از دفترچه تلفن انتخاب کنید',
                                textScaleFactor: 0.9,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10),
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
                                          if (v.isNotEmpty && v.length > 3 &&
                                              v.startsWith('09')) {
                                            setState(() {
                                              _selectedTopUpType = 0;
                                            });
                                            _onPhoneChange(v);
                                          } else {
                                            setState(() {
                                              _topUpOperator = -1;
                                            });
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                      )),
                                  GestureDetector(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: PColor.blueparto,
                                        borderRadius: BorderRadius.circular(10),
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
                              Divider(color: PColor.orangeparto,
                                indent: 5,
                                endIndent: 5,
                                thickness: 2,),
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
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: index == _topUpOperator
                                                    ? PColor.blueparto
                                                    : Colors.grey,
                                                width: 1),
                                            boxShadow: index == _topUpOperator
                                                ? [
                                              BoxShadow(
                                                  color: PColor.blueparto,
                                                  offset: Offset(0, 0),
                                                  spreadRadius: 1,
                                                  blurRadius: 1)
                                            ]
                                                : [
                                              BoxShadow(
                                                  color: PColor.orangeparto,
                                                  offset: Offset(0, 0),
                                                  spreadRadius: 0,
                                                  blurRadius: 0)
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  index == _topUpOperator
                                                      ? _operatorsWithLogo[index]
                                                      .colorImage
                                                      : _operatorsWithLogo[index]
                                                      .grayImage),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _topUpOperator = index;
                                          _selectedTopUpType = 0;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),

                              //بخش نمایش گزینه های تاپ آپ قابل انجام برای هر اپراتور
                              _selectedTopUpType != -1 && _topUpOperator != -1 ?
                              Column(
                                children: [
                                  Divider(color: PColor.orangeparto,
                                    indent: 5,
                                    endIndent: 5,
                                    thickness: 2,),
                                  Text(
                                    'یکی از روش های شارژ را انتخاب کنید',
                                    style: TextStyle(
                                        color: PColor.blueparto,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                  TopUpChargeTypes(_topUpOperator),

                                ],
                              ) :
                              Container(height: 0,),
                              // بخش نمایش مبالغ مربوط به گزینه تا آپ
                              _selectedTopUpType != -1 && _topUpOperator != -1 ?
                              Column(
                                children: [
                                  Divider(color: PColor.orangeparto,
                                    indent: 5,
                                    endIndent: 5,
                                    thickness: 2,),
                                  Text(
                                    'مبلغ شارژ مورد نظر را انتخاب کنید',
                                    style: TextStyle(
                                        color: PColor.blueparto,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                 Column(
                                   children: [
                                     Prices(_topUpOperator, _selectedTopUpType)
                                   ],
                                 )

                                  //Prices(_topUpOperator, _selectedTopUpType)

                                ],
                              ) :
                              Container(height: 0,)

                            ],
                          ) :
                          //بخش مربوط به کارت شارژ
                          Column(
                            children: [
                              Text(
                                'اپراتور کارت شارژ را وارد کنید',
                                style: TextStyle(
                                    color: PColor.blueparto,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                              Container(
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                height: 60,
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
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: index == _topUpOperator
                                                    ? PColor.blueparto
                                                    : Colors.grey,
                                                width: 1),
                                            boxShadow: index == _topUpOperator
                                                ? [
                                              BoxShadow(
                                                  color: PColor.blueparto,
                                                  offset: Offset(0, 0),
                                                  spreadRadius: 1,
                                                  blurRadius: 1)
                                            ]
                                                : [
                                              BoxShadow(
                                                  color: PColor.orangeparto,
                                                  offset: Offset(0, 0),
                                                  spreadRadius: 0,
                                                  blurRadius: 0)
                                            ],
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  index == _topUpOperator
                                                      ? _operatorsWithLogo[index]
                                                      .colorImage
                                                      : _operatorsWithLogo[index]
                                                      .grayImage),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _topUpOperator = index;
                                          _selectedTopUpType = 0;
                                        });
                                      },
                                    );
                                  },
                                ),
                              )

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
                      CButton(label: 'خرید', onClick: () {
                        if (_selectedChargeType == 0)
                          if (_topUpOperator == -1 ||
                              _mobile.text.length < 11) {
                            showDialog(context: context,
                                builder: (context) =>
                                    CAlertDialog(
                                      content: 'شماره همراه وارد شده درست نیست، لطفا شماره را بررسی کنید.',
                                      buttons: [
                                        CButton(label: 'بستن',
                                          onClick: () =>
                                              Navigator.of(context).pop(),)
                                      ],
                                    )
                            );
                          } else {
                            _sendToPayment();
                          }
                      }, minWidth: 150,),
                      CButton(label: 'تکرار خرید قبلی',
                        onClick: () {},
                        minWidth: 150,),

                    ],
                  ),
                ),
              ),
            ),
            PreInvoiceContainer(
              amount: _invoiceAmount,
              paymentLink: _paymentLink ,
              canUseWallet: _canUseWallet,
              walletAmount: _walletAmount,
              readyToPayment: _readyToPay,
              title: _invoiceTitle,
              subTitle: _invoiceSubTitle,


            )

          ],
        )
    );
  }

  //Detect operator of mobile with 3 number of starting
  _onPhoneChange(String number) {
    if (number.length > 2) {
      var _firstCharacter = number.substring(0, 3);
      switch (_firstCharacter) {
        case '091':
          {
            setState(() {
              _topUpOperator = 1;
            });
            setState(() {});
          }
          break;
        case '093':
          {
            setState(() {
              _topUpOperator = 0;
            });
            setState(() {});
          }
          break;
        case '092':
          {
            setState(() {
              _topUpOperator = 2;
            });
            setState(() {});
          }
          break;
        case '099':
          {
            setState(() {
              _topUpOperator = 3;
            });
            setState(() {});
          }
          break;

        default:
          {
            setState(() {
              _topUpOperator = -1;
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

