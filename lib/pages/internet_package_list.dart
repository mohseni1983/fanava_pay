import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/Pages/main_page.dart';
import 'package:parto_v/classes/global_variables.dart';
import 'package:parto_v/classes/internet_package.dart';
import 'package:parto_v/classes/wallet.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:parto_v/custom_widgets/cust_seletable_grid_item.dart';
import 'package:parto_v/custom_widgets/cust_seletable_package.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:parto_v/classes/auth.dart' as auth;

class InternetPackageListPage extends StatefulWidget {
  final int operatorId;
  final int simCardId;

  const InternetPackageListPage({Key key,  this.operatorId, this.simCardId}) : super(key: key);
  @override
  _InternetPackageListPageState createState() => _InternetPackageListPageState();
}



class _InternetPackageListPageState extends State<InternetPackageListPage> {
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


  List<DataPlan> _listOfPlans;
  @override
  void initState() {
    getDataPlans();
    // TODO: implement initState
    super.initState();


  }

  // get the list of packages;
  Future<void> getDataPlans() async{
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
              'https://www.idehcharge.com/Middle/Api/Charge/GetDataPlanList',
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
                _listOfPlans= internetPackageFromJson(result.body).dataPlans;

              });

            }else{
              showDialog(context: context,
                builder: (context) =>
                    CAlertDialog(content: 'خطا در دریافت اطلاعات',subContent: jResult['ResponseMessage'],buttons: [CButton(label: 'بستن',onClick: ()=>
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),))
                      ,)],) ,
              );
            }
          }
        }on TimeoutException catch(e){
          showDialog(context: context,
            builder: (context) => CAlertDialog(
              content: 'خطای ارتباط با سرور',
              subContent: 'سرور پاسخ نمی دهد، از اتصال اینترنت خود مطمئن شوید',
            ),
          );
        }
      }
    });
  }



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

  //create list of  packages
  int _selectedPeriod=0;
  List<DataPlan> _plans=[];
  void filterList({int operatorId,int simCardTypeId,int selectedPeriod=0,List<DataPlan> masterList})
  {
    getDataPlans();
    setState(() {
      _plans=masterList;
    });
    setState(() {
      _plans.retainWhere((element) => element.dataPlanOperator==operatorId && element.dataPlanType==simCardTypeId && element.period==_selectedPeriod);
      debugPrint(_listOfPlans.length.toString());

    });

  }



  //create list of periods
  Widget ListOfPeriods(){
    List<Widget> _list=[];
    _packages.forEach((key, value) {
      _list.add(

          CSelectedGridItem(

        height: 40,
       // width: 120,
            paddingHorizontal: 10,
        paddingVertical: 5,

        label: value,
        value: key,
        selectedValue: _selectedPeriod,
        onPress: (v){
          setState(() {
            _selectedPeriod=v;
            setState(() {
              filterList(selectedPeriod: _selectedPeriod,simCardTypeId: widget.simCardId,operatorId: widget.operatorId,masterList: _listOfPlans);
            });
          });
        },
      )
      );
    });
    return

      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:        ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Wrap(
              children: _list,
              direction: Axis.horizontal,
              spacing: 5,
            ),
          )
          ,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _inprogress,
        child: Stack(
          children: [
            MasterTemplateWithoutFooter(

              // inProgress: _inprogress,
                wchild: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      'بسته های اینترنت',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'یکی از بسته ها را انتخاب نمائید',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      color: PColor.orangeparto,
                      thickness: 2,
                    ),
                    Column(
                      children: [
/*
                        Text(
                          'یکی از دورها زمانی را انتخاب کنید',
                          textScaleFactor: 0.9,
                        ),
                        Divider(
                          color: PColor.orangeparto,
                          indent: 5,
                          endIndent: 5,
                          thickness: 2,
                        ),
*/
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 80,
                          child: ListOfPeriods()
                        ),
                        Divider(
                          color: PColor.orangeparto,
                          thickness: 2,
                        ),


                        //بخش نمایش گزینه های زمانی قابل انجام برای هر اپراتور



                        // بخش نمایش مبالغ مربوط به گزینه تا آپ

                      ],
                    ),

                    // بخش مربوط به اطلاعات اصلی
                    Expanded(
                        child:
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _plans.length,
                          itemBuilder: (context, index) {
                            var _item=_plans[index];
                            return CSelectedPackage(
                              value: _item.id,
                              label: _item.title,
                              selectedValue: _selectedPackage,
                              costWithTax: _item.priceWithTax,
                              costWithoutTax: _item.priceWithoutTax,
                              onPress: (v){
                                setState(() {
                                  _selectedPackage=v;
                                });
                              },
                            );
                          },

                        )

                    ),
                    Container(height: 90,)
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
/*
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
*/
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

  @override
  void dispose() {
    this.dispose();
  }





}
