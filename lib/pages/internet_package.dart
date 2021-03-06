import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fanava_payment/Pages/internet_package_list.dart';
import 'package:fanava_payment/Pages/main_page.dart';
import 'package:fanava_payment/classes/global_variables.dart';
import 'package:fanava_payment/classes/internet_package.dart';
import 'package:fanava_payment/classes/wallet.dart';
import 'package:fanava_payment/components/maintemplate_withoutfooter.dart';
import 'package:fanava_payment/custom_widgets/cust_alert_dialog.dart';
import 'package:fanava_payment/custom_widgets/cust_button.dart';
import 'package:fanava_payment/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:fanava_payment/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fanava_payment/classes/auth.dart' as auth;

class InternetPackagePage extends StatefulWidget {
  @override
  _InternetPackagePageState createState() => _InternetPackagePageState();
}

class _InternetPackagePageState extends State<InternetPackagePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _mobile = new TextEditingController();
  bool _progressing = false;
  String _paymentLink = '';

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
              '???? ?????? ???????????? ??????????????',
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
  Map<int,String>_packages= {0:'??????????',1:'????????????',2: '??????????',3:'????????????', 8:'????????????', 9:'???? ????????',10:'????????????????',4:'???? ????????', 5:'????????????'};

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
        name: '??????????????',
        colorImage: 'assets/images/mtn-color.jpg',
        grayImage: 'assets/images/mtn-gray.jpg',
      simTypes: [
        new SimCardTypes(id: 0,name: '??????????'),
        new SimCardTypes(id: 1,name: '??????????????'),
        new SimCardTypes(id: 2,name: '?????????????? TDLte'),
        new SimCardTypes(id: 4,name: '?????????? FDLte')
      ]
),
    new InternetPackageOperators(
        id: 1,
        name: '?????????? ??????',
        colorImage: 'assets/images/mci-color.jpg',
        grayImage: 'assets/images/mci-gray.jpg',
        simTypes: [
          new SimCardTypes(id: 0,name: '??????????'),
          new SimCardTypes(id: 1,name: '??????????????')
        ]),
    new InternetPackageOperators(
        id: 3,
        name: '??????????',
        colorImage: 'assets/images/rightel-color.jpg',
        grayImage: 'assets/images/rightel-gray.jpg',
        simTypes: [
          new SimCardTypes(id: 0,name: '??????????'),
          new SimCardTypes(id: 1,name: '??????????????'),
          new SimCardTypes(id: 3,name: '????????')
        ]),
    new InternetPackageOperators(
        id: 4,
        name: '???????? ????????????',
        colorImage: 'assets/images/shatel-color.jpg',
        grayImage: 'assets/images/shatel-gray.jpg',
        simTypes: [
          new SimCardTypes(id: 1,name: '??????????????'),
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



  // get the list of packages;
  List<DataPlan> _dataPlans=[];
  Future<List<DataPlan>> getDataPlans() async{
    setState(() {
      _progressing=true;
    });
    auth.checkAuth().then((value) async{
      if(value){
        SharedPreferences _prefs=await SharedPreferences.getInstance();
        String _token=_prefs.getString('token');
        String _sign=_prefs.getString('sign');
        var _body=json.encode({
          "LocalDate": DateTime.now().toString(),
          "Sign": _sign,
        });
        try{
          var result=await http.post(
              Uri.parse('https://www.idehcharge.com/Middle/Api/Charge/GetDataPlanList'),
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json'
              },
              body: _body
          ).timeout(Duration(seconds: 20));
          if(result.statusCode==401){
            auth.retryAuth().then((value) {
              getDataPlans();
            });
          }
          if(result.statusCode==200){
            setState(() {
              _progressing=false;
            });
            var jResult=json.decode(result.body);
            //debugPrint(jResult.toString());
            if(jResult['ResponseCode']==0){
              setState(() {
                _dataPlans=internetPackageFromJson(result.body).dataPlans;

              });
            }else{
              showDialog(context: context,
              builder: (context) =>
                  CAlertDialog(content: '?????? ???? ???????????? ??????????????',subContent: jResult['ResponseMessage'],buttons: [CButton(label: '????????',onClick: ()=>
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),))
                ,)],) ,
              );
            }
          }
        }on TimeoutException catch(e){
          showDialog(context: context,
            builder: (context) => CAlertDialog(
              content: '???????? ???????????? ???? ????????',
              subContent: '???????? ???????? ?????? ???????? ???? ?????????? ?????????????? ?????? ?????????? ????????',
            ),
          );
        }
      }
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _prefs.then((value)  {
       _mobile.text=value.getString('cellNumber');

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // inAsyncCall: _inprogress,
        body: Stack(
          children: [
            MasterTemplateWithoutFooter(

              // inProgress: _inprogress,
                wchild: Column(
                  children: [
                    //Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      '???????? ?????? ??????????????',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '?????????????? ?????????? ???? ???????? ???????? ???? ???????? ????????',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      color: PColor.orangeparto,
                      thickness: 2,
                    ),
                    // ?????? ?????????? ???? ?????????????? ????????
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
                                    '?????????? ?????????? ???????? ?????? ???? ???????? ?? ???? ???? ???????????? ???????? ???????????? ????????',
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
                                                hintText: '???????? 09123456789'),
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
                                              if(v.length==11)
                                                FocusScope.of(context).unfocus();


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
                                    '???? ???????? ???????????? ?????? ?????????????? ???? ?????????? ????????',
                                    style: TextStyle(
                                        color: PColor.blueparto,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                  //?????? ?????????? ???? ?????????? ?????? ?????? ???????? ?????? ????
                                  Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    height: 60,
                                    //???????? ???????? ?? ?????????? ???????????????????? ????????????
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

                                  //?????? ?????????? ?????????? ?????? sim ???????? ?????????? ???????? ???? ??????????????
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
                                        '?????? ?????? ???????? ???? ???????????? ????????',
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
                                  // ?????? ?????????? ?????????? ?????????? ???? ?????????? ???? ????

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
                        label: '????????',
                        onClick: () {
    if (_mobile.text.length<11) {
      showDialog(
          context: context,
          builder: (context) =>
              CAlertDialog(
                content: '?????? ???? ??????????',
                subContent:
                '?????????? ???????????? ???????? ????????',
                buttons: [
                  CButton(
                    label: '????????',
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
                                  content: '?????? ???? ???????????? ??????????????',
                                  subContent:
                                  '?????????????? ?????????? ???? ?????????????? ???????????? ???????? ??????',
                                  buttons: [
                                    CButton(
                                      label: '????????',
                                      onClick: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                ));
                          }

                          else {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetPackageListPage(operatorId: _selectedOperator,simCardId: _selectedSimCard,mobile: _mobile.text,),));
                           // _sendToPayment();
                          }
                        },
                        minWidth: 100,
                      ),

/*
                      CButton(
                        label: '?????????? ???????? ????????',
                        onClick: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => InternetPackageListPage(repeat:true),));

                        },
                        minWidth: 100,
                      ),
*/
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
