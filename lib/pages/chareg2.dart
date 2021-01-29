import 'dart:convert';

import 'package:fa_stepper/colors.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice.dart';
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

  bool _inprogress=false;

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
        _inprogress=true;

      });
      _payChargeWithCard(_current).then((value) {
        setState(() {
          _inprogress=false;
        });
      });

    });
  }

// List of master method of charging credit [مستقیم , کارت شارژ]
  List<String> _chargeTypes = ['شارژ مستقیم'];

  int _selectedAmount = 0;
  int _selectedChargeType = 0;
  int _selectedTopUpType = 0;

  List<FAStep> _buildSteps() {
    List<FAStep> _s = [
      FAStep(
        title: Text('روش\r\nخرید',style: TextStyle(fontFamily: 'IRANSans(FaNum)'),textScaleFactor: 0.7),
        //subtitle: Text('یکی از روش های خرید شارژ را انتخاب نمایید',textScaleFactor: 0.7,),

        content: Container(
            alignment: Alignment.center,
            //padding: EdgeInsets.all(7),
            width: MediaQuery.of(context).size.width,
            /* decoration: BoxDecoration(
            border: Border.all(color: PColor.orangeparto,style: BorderStyle.solid,width: 2),
            borderRadius: BorderRadius.circular(10),
            //color: Colors.white
          ),*/
            height: 180.0,
            // width: MediaQuery.of(context).size.width-100,
            margin: EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                Text(
                  'یکی از روش های خرید شارژ را انتخاب نمایید',
                  textScaleFactor: 0.9,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    //scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 3.6),

                    itemCount: _chargeTypes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2.3,
                          margin: EdgeInsets.fromLTRB(1, 4, 1, 4),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _selectedChargeType == index
                                ? PColor.blueparto
                                : PColor.orangeparto,
                          ),
                          child: Center(
                            child: Text(
                              '${_chargeTypes[index]}',
                              style: TextStyle(
                                color: _selectedChargeType == index
                                    ? Colors.white
                                    : PColor.blueparto,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedChargeType = index;
                          });
                        },
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    ];
    if (_selectedChargeType == 0) {
      _s.add(
        FAStep(
            title: Text('شماره\r\nموبایل',style: TextStyle(fontFamily: 'IRANSans(FaNum)'),textScaleFactor: 0.7),
            //subtitle: Text( 'شماره همراه مورد نظر را وارد و یا از دفترچه تلفن انتخاب کنید',      textScaleFactor: 0.7,),

            content: Container(
              height: 180,
              child: Column(
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
                              borderRadius: BorderRadius.circular(10),
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
                          if (v.isNotEmpty && v.length == 11 && v.startsWith('09')) {
                            setState(() {
                              _selectedTopUpType=0;
                            });
                            _onPhoneChange(v);
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
                        onTap: () {},
                      )
                    ],
                  ),
                  Divider(
                    color: PColor.orangeparto,
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
                                borderRadius: BorderRadius.circular(10),
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
                                  image: AssetImage(index == _topUpOperator
                                      ? _operatorsWithLogo[index].colorImage
                                      : _operatorsWithLogo[index].grayImage),
                                  fit: BoxFit.fill,
                                )),
                          ),
                          onTap: () {
                            setState(() {
                              _topUpOperator = index;
                              _selectedTopUpType=0;
                            });
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            )),
      );

      if (_selectedChargeType == 0 && _topUpOperator >= 0 && _topUpOperator!=10) {
        _s.add(FAStep(
            title: Text('روش\r\nشارژ',style: TextStyle(fontFamily: 'IRANSans(FaNum)'),textScaleFactor: 0.7),
            //subtitle:Text('یکی از روش های شارژ را انتخاب کنید',textScaleFactor: 0.7,) ,
            content: Container(
              height: 180,
              child: Column(
                children: [
                  Text(
                    'یکی از روش های شارژ را انتخاب کنید',
                    textScaleFactor: 0.9,
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                    ),
                    itemCount:
                        _operatorsWithLogo[_topUpOperator].chargeTypes.length,
                    itemBuilder: (context, index) {
                      var items =
                          _operatorsWithLogo[_topUpOperator].chargeTypes;
                      return GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2.3,
                          margin: EdgeInsets.fromLTRB(1, 4, 1, 4),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _selectedTopUpType == _operatorsWithLogo[_topUpOperator].chargeTypes[index].id
                                ? PColor.blueparto
                                : PColor.orangeparto,
                          ),
                          child: Center(
                            child: Text(
                              '${items[index].name}',
                              style: TextStyle(
                                color: _selectedTopUpType == _operatorsWithLogo[_topUpOperator].chargeTypes[index].id
                                    ? Colors.white
                                    : PColor.blueparto,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedTopUpType = _operatorsWithLogo[_topUpOperator].chargeTypes[index].id;
                          });
                        },
                      );
                    },
                  ))
                ],
              ),
            )));
      }

      if (_selectedChargeType == 0 &&
          _topUpOperator >= 0 &&
          _selectedTopUpType >= 0 && _topUpOperator!=10) {
        _s.add(FAStep(
            title: Text('مبلغ\r\nشارژ',style: TextStyle(fontFamily: 'IRANSans(FaNum)'),textScaleFactor: 0.7),
            //subtitle:Text('یکی از روش های شارژ را انتخاب کنید',textScaleFactor: 0.7,) ,
            content: Container(
              height: 180,
              child: Column(
                children: [
                  Text(
                    'مبلغ شارژ مورد نظر را انتخاب کنید',
                    textScaleFactor: 0.9,
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                    ),
                    itemCount: _operatorsWithLogo[_topUpOperator]
                        .chargeTypes[_selectedTopUpType]
                        .prices
                        .length,
                    itemBuilder: (context, index) {
                      var items = _operatorsWithLogo[_topUpOperator]
                          .chargeTypes[_selectedTopUpType]
                          .prices;
                      return GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2.3,
                          margin: EdgeInsets.fromLTRB(1, 4, 1, 4),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _selectedAmount == items[index]
                                ? PColor.blueparto
                                : PColor.orangeparto,
                          ),
                          child: Center(
                            child: Text(
                              '${items[index]} ریال',
                              style: TextStyle(
                                color: _selectedAmount == items[index]
                                    ? Colors.white
                                    : PColor.blueparto,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedAmount = items[index];
                          });
                        },
                      );
                    },
                  ))
                ],
              ),
            )));
      }
    } else
      _s.add(FAStep(
        isActive: false,
        title: Text('غیرفعال'),
        // subtitle: Text('یکی از روش های خرید شارژ را انتخاب نمایید'),

        content: Column(
          children: [
            Text('در حال حاضر این بخش غیر فعال است')
          ],
        ),
      ));
    return _s;
  }

  Widget _stepperWidget() {
    List<FAStep> _steps = _buildSteps();
    return FAStepper(
      //physics: ClampingScrollPhysics(),
      key: Key('custStepper' + _steps.length.toString()),

      currentStep: _currentStep,
      titleIconArrange: FAStepperTitleIconArrange.row,
      onStepContinue: () {

        if (_currentStep < _steps.length )
          if(_currentStep==1)
          {
            if(!_mobile.text.startsWith('09') || _mobile.text.length<11 || _topUpOperator==10 )
              {
                showDialog(context: context,
                  builder: (context) => CAlertDialog(content: 'شماره موبایل وارد شده صحیح نیست',buttons: [
                    CButton(
                      label: 'بستن',
                      onClick: ()=>Navigator.of(context).pop(),
                    )
                  ],),
                );
                return;
              }
          }
        setState(() {
           _currentStep++;
        });
      },
      onStepCancel: () {
        if (_currentStep > 0)
          setState(() {
            _currentStep--;
          });
      },
      onStepTapped: (v) {
        setState(() {
          _currentStep = v;
        });
      },

      type: FAStepperType.horizontal,
      stepNumberColor: Colors.deepOrange,
      //titleHeight: 25,
      controlsBuilder: (context, {onStepCancel, onStepContinue}) {
        return Row(
          mainAxisAlignment: _currentStep > 0
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            _currentStep > 0
                ? MaterialButton(
                    onPressed: onStepCancel,
                    child: Text('قبلی'),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            _currentStep < _steps.length - 1 || _currentStep==1
                ? CButton(
                    onClick: onStepContinue,
                    label: 'بعدی',
                    minWidth: 120,
                  )
                : CButton(
                    onClick: _sendToPayment,
                    label: 'خرید',
                    minWidth: 120,
                  ),
          ],
        );
      },

      steps: _steps,
    );
  }

  Future<void> _payChargeWithCard(TopUp topUp) async {
    auth.checkAuth().then((value) async{
      if (value) {
      SharedPreferences _p = await SharedPreferences.getInstance();
      String _token = _p.getString('token');
      var jsonTopUp=topUpToJson(topUp);
      var result = await http.post(
      'https://www.idehcharge.com/Middle/Api/Charge/TopUp',
      headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json'
      },
      body: jsonTopUp);
      if(result.statusCode==401){
        auth.retryAuth().then((value) {
          _payChargeWithCard(topUp);
        });
      }
      if (result.statusCode == 200) {
        debugPrint(result.body);
      var jres=json.decode(result.body);

      if(jres['ResponseCode']==0)
        showDialog(context: context,
          builder: (context) {
            return PreInvoice(
              title: '${_chargeTypes[_selectedChargeType] }  ${_operatorsWithLogo[_topUpOperator].name}',
              subTitle: '${_operatorsWithLogo[_topUpOperator].chargeTypes[_selectedTopUpType].name}',
              amount: _selectedAmount.toDouble(),
              canUseWallet: jres['CanUseWallet'],
              paymentLink: jres['Url'],
              walletAmount: 0,

            );
          },

        );
      else if(jres['ResponseCode']==5)
        {
          auth.retryAuth().then((value) {
            _payChargeWithCard(topUp);
          });
        }
      else
        showDialog(context: context,
          builder: (context) => CAlertDialog(
            content: jres['ResponseMessage'],
            buttons: [CButton(label: 'بستن',onClick: ()=>Navigator.of(context).pop(),)],
          ),
        );

      }
      } else
      showDialog(context: context,
      builder: (context) => CAlertDialog(
        content: 'خطا در احراز هویت',
        buttons: [CButton(label: 'بستن',onClick: ()=>Navigator.of(context).pop(),)],
      ),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(inAsyncCall: _inprogress,
        child: MasterTemplate(
           // inProgress: _inprogress,
            wchild: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  'شارژ تلفن همراه',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'اطلاعات مربوط به خرید شارژ را وارد کنید',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: PColor.orangeparto,
                  thickness: 2,
                ),
                Expanded(child: _stepperWidget())
              ],
            )

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
              _topUpOperator = 10;
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
}


