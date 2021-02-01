import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parto_v/classes/account_trans.dart';
import 'package:parto_v/classes/convert.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _progressing=false;
  TextEditingController _startDatePicker=new TextEditingController();
  TextEditingController _endDatePicker=new TextEditingController();
  PersianDatePickerWidget _startPickerWidget;
  PersianDatePickerWidget _endPickerWidget;
  List<TxnInfoListElement> _transList=[];
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
      fontFamily: 'Dirooz',
      datetime: getPersianDate(DateTime.now().add(Duration(days: -1))).toString(),
      headerTodayBackgroundColor: PColor.orangeparto,
      farsiDigits: false,
      headerBackgroundColor: PColor.orangeparto,
      headerTodayIcon: Icon(Icons.today_rounded,color: PColor.blueparto,),
      selectedDayBackgroundColor: PColor.orangepartoAccent,
      weekCaptionsBackgroundColor: PColor.blueparto,
      rangeDatePicker: false,

    ).init();
    _endPickerWidget=PersianDatePicker(
      controller: _endDatePicker,
      fontFamily: 'Dirooz',
      farsiDigits: false,

      datetime: getPersianDate(DateTime.now()).toString(),
      headerTodayBackgroundColor: PColor.orangeparto,
      headerBackgroundColor: PColor.orangeparto,
      headerTodayIcon: Icon(Icons.today_rounded,color: PColor.blueparto,),
      selectedDayBackgroundColor: PColor.orangepartoAccent,
      weekCaptionsBackgroundColor: PColor.blueparto,
      rangeDatePicker: false,

    ).init();


    super.initState();
    setState(() {
      _progressing=true;
      getAcountTransactions(pageNumber: _currentPage,
          startDate: DateTime.now().add(Duration(days: -365)),
          endDate: DateTime.now(),
          pageSize: 15).then((value) {
            setState(() {

            });
      });


    });
  }
  //پروگرس ارتباط با سرور جهت دریافت اطلاعات
  bool _inprogress = false;
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







  //بخش دریافت لیست تراکنش های کیف پول
  Future<void> getAcountTransactions({int pageNumber,DateTime startDate,DateTime endDate,int pageSize}) async{
    setState(() {
      isLoading=true;

    });
    auth.checkAuth().then((value) async{
      if (value)
        try
        {
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
              'https://www.idehcharge.com/Middle/Api/Charge/GetTxnInfo',
              headers: {
                'Authorization': 'Bearer $_token',
                'Content-Type': 'application/json'
              },
              body: _jBody
          ).timeout(Duration(seconds: 20));
          if (result.statusCode==401)
          {
            auth.retryAuth().then((value) {
              getAcountTransactions(pageNumber: pageNumber,startDate: startDate,endDate: endDate,pageSize: pageSize);
            });
          }
          if(result.statusCode==200){
            setState(() {
              _progressing=false;
              isLoading=false;
            });
            debugPrint(result.body);
            var jres=json.decode(result.body);
            //debugPrint(jres.toString());


            if(jres['ResponseCode']==0){
              var _financeList=jres['TxnInfoList'];
              debugPrint(jres.toString());
              AcountTransTxnInfoList _list= AcountTransTxnInfoList.fromJson(_financeList);
              setState(() {
                _transCount=_list.totalCounts;
                _transList.addAll(_list.txnInfoLists);
              });
            }


          }
        }
        on TimeoutException catch(e){
          showDialog(
            context: context,
            builder: (context) =>
                CAlertDialog(
                  content: 'خطای ارتباط',
                  subContent: 'ارتباط با سرور بر قرار نشد',
                  buttons: [
                    CButton(
                      label: 'بستن',
                      onClick: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
          );
        }
    });
  }

  bool isLoading=false;
  int pageSize=10;
  int _currentPage=1;
  Widget MakeListOfTrans(){
    return
      NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              // start loading data
              if(_currentPage<=(_transCount/pageSize).ceil())
              {
                setState(() {
                  _currentPage++;
                  isLoading = true;
                });
                getAcountTransactions(pageNumber: _currentPage,
                    startDate: DateTime.now().add(Duration(days: -365)),
                    endDate: DateTime.now(),
                    pageSize: pageSize);
              }
            }
            return true;
          },



          child:         ListView.builder(
            //shrinkWrap: true,

            itemCount: _transList.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              var _item=_transList[index];
              return Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  height: 80,
                  //color: Colors.green,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                      color: PColor.orangepartoAccent,
                      borderRadius: BorderRadius.circular(12)

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 8,
                        height: 67,
                        decoration: BoxDecoration(
                            color: _item.isSettle?Colors.green:Colors.red,
                            borderRadius: BorderRadius.horizontal(left:Radius.circular(12) )

                        ),

                      ),
                      Container(
                        width: 20,
                      ),
                      Expanded(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_item.requestTypeDetails}',textAlign: TextAlign.right,textScaleFactor: 1.1,style: TextStyle(fontWeight: FontWeight.bold,color: PColor.blueparto),),

                              _item.isSettle &&  _item.rrn!=null && _item.rrn.length>0?

                              Container(

                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: PColor.orangeparto,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('پیگیری: ${_item.rrn}',style: TextStyle(color: PColor.blueparto,fontWeight: FontWeight.bold),textScaleFactor: 0.9,),
                              ):

                                  Container(height: 0,width: 0,)

                            ],
                          ),

/*
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${_item.description}',style: TextStyle(color: PColor.blueparto.shade300,fontWeight: FontWeight.bold,fontSize: 10),)
                            ],
                          ),
*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_item.requestDate}',style: TextStyle(fontWeight: FontWeight.bold,color: PColor.orangeparto),textScaleFactor: 0.8,),
                              _item.isSettle?
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${getMoneyByRial(_item.amount.toInt())} ریال',style: TextStyle(color: Colors.green.shade700),),
                                  Icon(Icons.check_circle,color: Colors.green.shade600,)
                                ],
                              ):
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${getMoneyByRial((_item.amount).toInt())} ریال',style: TextStyle(color: Colors.red.shade700),),
                                  Icon(Icons.block_rounded,color: Colors.red.shade600,)
                                ],
                              ),



                            ],
                          ),
                          Container(
                            width: 20,
                          ),
                        ],
                      ))
                    ],
                  )
              );
            },
          )
      );
  }

//دریافت رنگ و شرح نوع تراکنش
  TransactionType getTransactionType(int id){
    switch(id){
      case 6:
        return TransactionType(color: Colors.blue,name: 'شارژ کیف پول');
        break;
      case 0:
        return TransactionType(color: Colors.green,name: 'شارژ موبایل');
        break;
      default:
        return TransactionType(color: PColor.blueparto,name: 'تراکنش مدل $id');
        break;
    }
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
                    'تراکنش های حساب',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline1,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    ' گزارش تراکنش های بانکی',
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
                  MakeListOfTrans()
                  ),
                  isLoading?
                  Container(
                    height: 10,
                    child: LinearProgressIndicator(),
                  ):
                  Container(height: 0,)



                ],
              )

          ),
          _progressing?
          Progress():Container(height: 0,),

        ],
      );

  }




  @override
  void dispose() {
    this.dispose();
  }




}

class TransactionType{

  String name;
  Color color;

  TransactionType({ this.name, this.color});
}

