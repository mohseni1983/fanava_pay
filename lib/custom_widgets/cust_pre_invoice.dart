import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum paymentTypes{
  Charge,
  Bill,
  InternetPackage
}

class PreInvoice extends StatefulWidget {
  final TopUp paymentInfo;
  final paymentTypes paymentType;


  const PreInvoice({ Key key, this.paymentInfo, this.paymentType }):super(key: key) ;
  @override
  _PreInvoiceState createState() => _PreInvoiceState();
}

class _PreInvoiceState extends State<PreInvoice> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();

  Future<void> _payChargeWithCard(TopUp topUp) async{
   SharedPreferences _p=await SharedPreferences.getInstance();
   String _token=_p.getString('token');
   var sss=topUpToJson(topUp);
   var result=await http.post('https://www.idehcharge.com/Middle/Api/Charge/TopUp',

   headers: {
     'Authorization': 'Bearer $_token',
     'Content-Type': 'application/json'

   },
     body: topUpToJson(topUp)
   );
   if(result.statusCode==200){
     var jres=json.decode(result.body);
     if(jres['ResponseCode']==0){
       var _url=jres['Url'];
       if(await canLaunch(_url))
         await launch(_url);
       else
         CAlertDialog(
           content: 'امکان اتصال به درگاه پرداخت وجود ندارد',

         );
     }else{
       CAlertDialog(
         content: jres['ResponseMessage'],

       );

     }
   }



  }

  List<String> _OperatorName=[
    'ایرانسل',
    'همراه اول',
    'رایتل',
    'شاتل موبایل'
  ];

  List<String> _ChargeVariety=[
    'معمولی',
    'شگفت انگیز',
    'بانوان',
    'جوانان'
  ];

  String _getPaymentTypeName(paymentTypes type){
    switch(type){
      case paymentTypes.Bill:
        return 'پرداخت قبض';
        break;
      case paymentTypes.Charge:
        return 'خرید شارژ';
        break;
      case paymentTypes.InternetPackage:
        return 'خرید بسته اینترنت';
        break;
      default:
        return 'دیگر پرداخت ها';
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
        child:
        Dialog(
            elevation: 55,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),



            ),
            backgroundColor: Colors.transparent,
            //backgroundColor: PColor.orangeparto,
            //insetPadding: EdgeInsets.all(15),
            child:
            Stack(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width/4*3,
                    height: MediaQuery.of(context).size.height-350,
                    //height: 200,
                    decoration: BoxDecoration(
                        color: PColor.orangeparto.shade400,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: PColor.blueparto,width: 3)
                    ),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(top: 35,bottom: 25),
                    child:ListView(
                      children: [
                        Text('اطلاعات پرداخت',textScaleFactor: 1.3,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        Divider(color: Colors.white,thickness: 2,height: 4,indent: 5,endIndent: 5,),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('نوع پرداخت',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),
                            Text('${_getPaymentTypeName(widget.paymentType)}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('نوع تراکنش',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),
                            widget.paymentType==paymentTypes.Charge?
                            Text('${_ChargeVariety[widget.paymentInfo.chargeType]}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.bold),):
                                Container(height: 0,)
                          ],

                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('مبلغ تراکنش',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),
                            Text('${widget.paymentInfo.amount}ریال',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('مالیات',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),
                            Text('${(widget.paymentInfo.amount*0.09).toInt()}ریال',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.bold),),


                          ],
                        ),
                        Divider(color: Colors.white,thickness: 2,height: 4,indent: 5,endIndent: 5,),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('مبلغ قابل پرداخت',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal),),
                            Text('${(widget.paymentInfo.amount*0.09+widget.paymentInfo.amount).toInt()}ریال',style: TextStyle(color: PColor.blueparto,fontSize: 16,fontWeight: FontWeight.bold),),


                          ],
                        ),






                      ],
                    )
                ),
                Positioned(
                  //top: -15,
                    right: MediaQuery.of(context).size.width/4*3/2-25,
                    child:
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: PColor.blueparto,
                        child: Icon(Icons.close_rounded,size: 30,color: Colors.white,),

                      ),

                    )
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceAround,
                      children: [
                        CButton(
                        label: 'پرداخت با درگاه بانکی',
                          onClick: () async{
                          switch(widget.paymentType){
                            case paymentTypes.Charge:
                              {
                                _payChargeWithCard(widget.paymentInfo);

                              }
                              break;
                            default:
                              break;
                          }

                          },


                      )] ,
                    )
                )


              ],

            )

        )
    );
  }
}