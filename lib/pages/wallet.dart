import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:parto_v/classes/convert.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/classes/wallet_trans.dart';
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
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:intl/intl.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _progressing=false;

  TextEditingController _startDatePicker=new TextEditingController();
  TextEditingController _endDatePicker=new TextEditingController();
  PersianDatePickerWidget _startPickerWidget;
  PersianDatePickerWidget _endPickerWidget;
  List<FinancingInfoListElement> _transList=[];
  int _transCount=0;


  PersianDateTime getPersianDate(DateTime dateTime){
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    PersianDateTime todayPersianDate=PersianDateTime.fromGregorian(gregorianDateTime: formatter.format(dateTime));
    return todayPersianDate;


  }

  @override
  void initState() {
    // TODO: implement initState


    _startPickerWidget=PersianDatePicker(
      controller: _startDatePicker,
      //datePickerHeight: 80,
      fontFamily: 'Dirooz',
      datetime: getPersianDate(DateTime.now().add(Duration(days: -1))).toString(),
      headerTodayBackgroundColor: PColor.orangeparto,
      farsiDigits: false,
      //daysBackgroundColor: PColor.blueparto,
      headerBackgroundColor: PColor.orangeparto,
      headerTodayIcon: Icon(Icons.today_rounded,color: PColor.blueparto,),
      selectedDayBackgroundColor: PColor.orangepartoAccent,
      weekCaptionsBackgroundColor: PColor.blueparto,
      //datetime: todayPersianDate.toString(),
      //maxDatetime: todayPersianDate.toString(),
      rangeDatePicker: false,
      //rangeSeparator: '/',

    ).init();
    _endPickerWidget=PersianDatePicker(
      controller: _endDatePicker,
      //datePickerHeight: 80,
      fontFamily: 'Dirooz',
      farsiDigits: false,

      datetime: getPersianDate(DateTime.now()).toString(),
      headerTodayBackgroundColor: PColor.orangeparto,
      //daysBackgroundColor: PColor.blueparto,
      headerBackgroundColor: PColor.orangeparto,
      headerTodayIcon: Icon(Icons.today_rounded,color: PColor.blueparto,),
      selectedDayBackgroundColor: PColor.orangepartoAccent,
      weekCaptionsBackgroundColor: PColor.blueparto,
      //datetime: todayPersianDate.toString(),
      //maxDatetime: todayPersianDate.toString(),
      rangeDatePicker: false,
      //rangeSeparator: '/',

    ).init();

    super.initState();
  }



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
        height: 35,
        selectedValue: _selectedWalletOperation,
        onPress: (x) {
          setState(() {
            _selectedWalletOperation = x;
          });
          if(x==1)
            setState(() {
            getWalletTransactions(pageNumber: 1,startDate: DateTime.now().add(Duration(days: -1)),endDate: DateTime.now(),pageSize: 3).then((value) {
              setState(() {
                _transList=value.financingInfoLists;
                _transCount=value.totalCounts;
              });
            });

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
  List<int> _predefinedAmountList=[500000,750000,1000000];
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

  //بخش دریافت لیست تراکنش های کیف پول
  Future<WalletTransFinancingInfoList> getWalletTransactions({int pageNumber,DateTime startDate,DateTime endDate,int pageSize}) async{
    setState(() {
      _progressing=true;
    });
    auth.checkAuth().then((value) async{
      if (value) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();


        String _sign = _prefs.getString('sign');
        String _token = _prefs.get('token');
        var _body={
          "LocalDate": DateTime.now().toString(),
          "Sign": _sign,
          "UseWallet": true,
          "CurrentPage": pageNumber,
          "DateFrom": startDate.toString(),
          "DateTo": endDate.toString(),
          "PageSize": pageSize,
          "UseWallet": true

        };
        var _jBody=json.encode(_body);
        var result = await http.post(
            'https://www.idehcharge.com/Middle/Api/Charge/GetFinancingInfo',
            headers: {
              'Authorization': 'Bearer $_token',
              'Content-Type': 'application/json'
            },
            body: _jBody
        );
        if (result.statusCode==401)
        {
          auth.retryAuth().then((value) {
            getWalletTransactions(pageNumber: pageNumber,startDate: startDate,endDate: endDate,pageSize: pageSize);
          });
        }
        if(result.statusCode==200){
          setState(() {
            _progressing=false;
          });
          debugPrint(result.body);
          var jres=json.decode(result.body);

          if(jres['ResponseCode']==0){
            var _financeList=jres['FinancingInfoList'];
            debugPrint(jres);
            WalletTransFinancingInfoList _list= WalletTransFinancingInfoList.fromJson(_financeList);
            return _list;
          }

        }
      }
    });





  }


  Widget MakeListOfTrans(){
      return
        ListView.builder(
          itemCount: _transList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            var _item=_transList[index];
            return Container(
              color: Colors.green,
              margin: EdgeInsets.all(5),
              child: Text('${ _item.transactDate }'),
            );
          },
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
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border: Border.all(color: PColor.orangeparto,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Text('عملیات مورد نظر را انتخاب کنید',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            Divider(color: PColor.orangeparto,
                              indent: 5,
                              endIndent: 5,
                              height: 0,
                              thickness: 2,),
                            WalletOperationTypes(),
                          ],
                        ),
                      ),
                      Container(
                        //height: 50,
                        padding: EdgeInsets.all(1),
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
                        //بخش مربوط به شارژ کیف
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
                        //بخش مربوط به گزارش
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(child:
                                    Column(
                                      children: [
                                        Text('تاریخ شروع',textScaleFactor: 0.9,style: TextStyle(color: PColor.blueparto),),
                                        TextField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              gapPadding: 2,
                                            ),
                                            hintText: 'تاریخ شروع',
                                            suffixIcon: Icon(
                                              Icons.calendar_today_rounded,
                                              color: PColor.orangeparto,
                                            ),
                                            fillColor: Colors.white,
                                            counterText: '',
                                          ),
                                          controller: _startDatePicker,
                                          enableInteractiveSelection: false, // *** this is important to prevent user interactive selection ***
                                          onTap: () {
                                            FocusScope.of(context).requestFocus(new FocusNode()); // to prevent opening default keyboard
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    child: Column(
                                                      children: [
                                                        _startPickerWidget,
                                                        CButton(label: 'بستن',onClick: ()=>Navigator.of(context).pop(),)
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          textAlign: TextAlign.center,
                                        ),

                                      ],
                                    )
                                ),
                               Padding(padding: EdgeInsets.only(left: 3)),
                               Expanded( child:
                                   Column(
                                     children: [
                                       Text('تاریخ پایان',textScaleFactor: 0.9,style: TextStyle(color: PColor.blueparto),),
                                       TextField(
                                         decoration: InputDecoration(
                                           border: OutlineInputBorder(
                                             borderRadius:
                                             BorderRadius.circular(10),
                                             gapPadding: 2,
                                           ),
                                           hintText: 'تاریخ پایان',
                                           suffixIcon: Icon(
                                             Icons.calendar_today_rounded,
                                             color: PColor.orangeparto,
                                           ),
                                           fillColor: Colors.white,
                                           counterText: '',
                                         ),
                                         controller: _endDatePicker,
                                         enableInteractiveSelection: false, // *** this is important to prevent user interactive selection ***
                                         onTap: () {
                                           FocusScope.of(context).requestFocus(new FocusNode()); // to prevent opening default keyboard
                                           showModalBottomSheet(
                                               context: context,
                                               builder: (BuildContext context) {
                                                 return Container(
                                                   child: Column(
                                                     children: [
                                                       _endPickerWidget,
                                                       CButton(label: 'بستن',onClick: ()=>Navigator.of(context).pop(),)
                                                     ],
                                                   ),
                                                 );
                                               });
                                         },
                                         textAlign: TextAlign.center,
                                       )

                                     ],
                                   )
                               ),


                              ],
                            ),
                            Container(
                              height: 300,
                              child: MakeListOfTrans(),
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

