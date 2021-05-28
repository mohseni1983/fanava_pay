import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fanava_payment/classes/account_trans.dart';
import 'package:fanava_payment/classes/convert.dart';
import 'package:fanava_payment/components/maintemplate_withoutfooter.dart';
import 'package:fanava_payment/custom_widgets/cust_alert_dialog.dart';
import 'package:fanava_payment/custom_widgets/cust_button.dart';
import 'package:fanava_payment/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fanava_payment/classes/auth.dart' as auth;
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:intl/intl.dart' as intl;
import 'package:share/share.dart';

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
  TxnInfoListElement _element=new TxnInfoListElement();
  int _transCount=0;
  PersianDateTime getPersianDate(DateTime dateTime){
    intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
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


  Widget _reportDialog(TxnInfoListElement _element) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),



      ),
      backgroundColor: PColor.blueparto,
      child:    Directionality(
        textDirection: TextDirection.rtl,
        child:       Material(
          color: Colors.transparent,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.7 + 30,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  //width: MediaQuery.of(context).size.width - 30,
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: PColor.blueparto,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25)),
                      boxShadow: [
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              'اطلاعات تراکنش',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textScaleFactor: 1.3,
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
                                    children: [
                                      Text('شرح تراکنش',style: TextStyle(color: Colors.white,fontSize: 12),),

                                    ],
                                  ),
                                  Container(
                                    child: Text('${_element.description}',style: TextStyle(color: PColor.orangepartoAccent,fontSize: 10),textAlign: TextAlign.right,),
                                  ),
                                  Divider(height: 1,thickness: 0.5,color: Colors.white,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('تاریخ تراکنش',style: TextStyle(color: Colors.white,fontSize: 10),),
                                      Text('${_element.requestDate}',style: TextStyle(color: PColor.orangepartoAccent,fontSize: 10),),


                                    ],
                                  ),
                                  Divider(height: 1,thickness: 0.5,color: Colors.white,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('وضعیت تراکنش',style: TextStyle(color: Colors.white,fontSize: 10),),
                                      _element.isCharge?Text('موفق',style: TextStyle(color: PColor.orangepartoAccent,fontSize: 10),):_element.isReverse?Text('برگشت وجه',style: TextStyle(color: PColor.orangepartoAccent,fontSize: 10),):Text('ناموفق',style: TextStyle(color: PColor.orangepartoAccent,fontSize: 10),),


                                    ],
                                  ),
                                  Divider(height: 1,thickness: 0.5,color: Colors.white,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('شناسه تراکنش',style: TextStyle(color: Colors.white,fontSize: 10),),
                                      Text('${_element.id}',style: TextStyle(color: PColor.orangepartoAccent,fontSize: 10),),


                                    ],
                                  ),





                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CButton(
                              label: 'اشتراک گذاری',
                              fontSize: 10,
                              minWidth: 90,

                              color: PColor.orangeparto,
                              textColor: Colors.white,
                              onClick: () async{
                                String st= _element.isCharge?'موفق':_element.isReverse?'برگشت وجه':'ناموفق';

                                    await Share.share('پرتو پرداخت\r\n'
                                    '${_element.description}\r\n'
                                    'نتیجه تراکنش:$st',);
                              },


                            ),
                            CButton(
                              label: 'بستن',
                              fontSize: 12,
                              minWidth: 90,
                              color: PColor.orangeparto,
                              textColor: Colors.white,
                              onClick: (){
                                Navigator.of(context).pop();


                              },
                            )

                          ],
                        ),
                        //  color: Colors.red,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

      )

    )
    ;

  }





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
              Uri.parse('https://www.idehcharge.com/Middle/Api/Charge/GetTxnInfo'),
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
            debugPrint(jres.toString());


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
              return
              GestureDetector(
                child:                 Container(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    //height: 100,
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
                          width: 4,
                          height: 67,
                          decoration: BoxDecoration(
                              color: _item.isCharge?Colors.green:Colors.red,
                              borderRadius: BorderRadius.horizontal(left:Radius.circular(12) )

                          ),

                        ),
                        Container(
                          width: 10,
                        ),
                        Expanded(child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_item.requestTypeDetails}',textAlign: TextAlign.right,textScaleFactor: 0.9,style: TextStyle(fontWeight: FontWeight.bold,color: PColor.blueparto),),



                                Container(

                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: PColor.orangeparto,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text('شناسه: ${_item.id}',style: TextStyle(color: PColor.blueparto,fontWeight: FontWeight.bold),textScaleFactor: 0.7,),
                                )

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_item.requestDate}',style: TextStyle(fontWeight: FontWeight.bold,color: PColor.orangeparto),textScaleFactor: 0.8,),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${getMoneyByRial(_item.amount.toInt())} ریال',style: TextStyle(color: PColor.blueparto),),
                                    // Icon(Icons.check_circle,color: Colors.green.shade600,)
                                  ],
                                ),




                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)

                              ),
                              //height: 60,
                              child: Row(
                                children: [
                                  Container(
                                    //width: 80,
                                    child: Column(
                                      children: [
                                        Text('وضعیت پرداخت',textScaleFactor: 0.7,),
                                        // Text('${_transList[index].requestType}',textScaleFactor: 0.7,),
                                        _item.isSettle?Icon(Icons.check,color: Colors.green,):Icon(Icons.block_flipped,color: Colors.red,)


                                      ],
                                    ),

                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.keyboard_arrow_left),
                                  ),
                                  Container(
                                    //width: 80,
                                    child: Column(
                                      children: [
                                        Text('وضعیت عملیات',textScaleFactor: 0.7,),
                                        // Text('${_transList[index].requestType}',textScaleFactor: 0.7,),
                                        _item.isCharge?Icon(Icons.check,color: Colors.green,):Icon(Icons.block_flipped,color: Colors.red,)


                                      ],
                                    ),

                                  ),
                                  !_item.isCharge?
                                  Container(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.keyboard_arrow_left),
                                  )
                                      :
                                  Container(width: 0,),
                                  !_item.isCharge?
                                  Container(
                                    // width: 80,
                                    child: Column(
                                      children: [
                                        Text('برگشت وجه',textScaleFactor: 0.7,),
                                        //Text('${_item.payRollBackDate}',textScaleFactor: 0.7,),

                                        // Text('${_transList[index].requestType}',textScaleFactor: 0.7,),
                                        _item.isReverse?Icon(Icons.check,color: Colors.green,):Icon(Icons.block_flipped,color: Colors.red,)



                                      ],
                                    ),

                                  )
                                      :
                                  Container(width: 0,),



                                ],
                              ),
                            )
                          ],
                        )
                        ),
                        Container(
                          alignment: Alignment.center,
                          //width: 20,
                          child: Icon(
                            Icons.arrow_right_outlined,color: PColor.orangeparto,size: 20,
                          ),

                        ),


                      ],
                    )
                )
                ,
                onTap: (){
                  showDialog(context: context,
                  builder: (context) => _reportDialog(_item),
                  );
                },
              )
              ;
            },
          )
      );
  }
/*                               GestureDetector(
                                child:
                                Container(
                                  width: 20,
                                  child: Icon(
                                      Icons.arrow_right_outlined
                                  ),

                                ),

                              )
*/
//دریافت رنگ و شرح نوع تراکنش
  TransactionType getTransactionType(int id){
    switch(id){
      case 0:
        return TransactionType(color: Colors.green,name: 'شارژ موبایل');
        break;
      case 1:
        return TransactionType(color: Colors.green,name: 'بسته های اینترنتی');
        break;
      case 2:
        return TransactionType(color: Colors.green,name: 'پرداخت قبض خدماتی');
        break;
      case 3:
        return TransactionType(color: Colors.green,name: 'کارت شارژ');
        break;
      case 4:
        return TransactionType(color: Colors.green,name: 'استعلام قبض خدماتی');
        break;
      case 5:
        return TransactionType(color: Colors.green,name: 'استعلام بسته های اینترنتی');
        break;
      case 6:
        return TransactionType(color: Colors.green,name: 'شارژ حساب کیف پول');
        break;
      case 14:
        return TransactionType(color: Colors.green,name: 'نیکوکاری');
        break;
      default:
        return TransactionType(color: PColor.blueparto,name: 'تراکنش مدل $id');
        break;
    }
  }


Widget buttom=Container(height: 0,);


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
                    ' گزارش تراکنش ها',
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

          buttom,

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

