import 'package:barcode_scan_fork/barcode_scan_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  bool _progressing = false;
  String _billId='';
  String _paymentId='';
  double _billPrice=0;
  bool _payWithBarcode=false;

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
  
  setBarcodeData(String barcode){
    setState(() {
      _billId=barcode.substring(0,5);
      _paymentId=barcode.substring(10,5);
     // _billPrice=double.parse(barcode.substring(13,8));
    });
  }


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this._billId=barcode.substring(0,13);
        this._paymentId=barcode.substring(17);
      double f=double.parse(barcode.substring(13,21));
       this._billPrice=(f*1000) ;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showDialog(context: context,
        builder: (context) => CAlertDialog(
          content: 'خطا در دوربین',
          subContent: 'اپلیکیشن اجازه دسترسی به دوربین را ندارد',
          buttons: [
            CButton(
              label: 'بستن',
              onClick: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        );
      } else {
        showDialog(context: context,
          builder: (context) => CAlertDialog(
            content: 'خطای ناشناخته',
            subContent: 'در فرآیند خطایی رخ داده است',
            buttons: [
              CButton(
                label: 'بستن',
                onClick: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );      }
    } on FormatException{
      showDialog(context: context,
        builder: (context) => CAlertDialog(
          content: 'خطا در خواندن',
          subContent: 'قبل از خواندن قبض دکمه برگشت زده شده است',
          buttons: [
            CButton(
              label: 'بستن',
              onClick: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );    } catch (e) {
      showDialog(context: context,
        builder: (context) => CAlertDialog(
          content: 'خطای بارکد',
          subContent: 'بارکد اسکن شده معتبر نیست',
          buttons: [
            CButton(
              label: 'بستن',
              onClick: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );        }
  }

  Widget PayWithBarcode(){
    return
      Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
            color: PColor.orangeparto,
            width: 2,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Text(
            'پرداخت با بارکد',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(
            color: PColor.orangeparto,
            indent: 5,
            endIndent: 5,
            thickness: 2,
          ),
          Row(
            children: [
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('شناسه قبض:$_billId'),
                  Text('شناسه پرداخت: $_paymentId'),
                  Text('مبلغ:${_billPrice}ریال')
                ],
              )),
              GestureDetector(
                  child: Container(
                    width: 90,
                    height: 90,
                    color: Colors.greenAccent,
                    child: Icon(Icons.qr_code_scanner_rounded),
                  ),
                  onTap: () =>scan()
              )
            ],
          )
        ],
      ),
    );

  }

  Widget PayWithOpetions(){
    return                   Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Text('TEST'),
            Container(
              height: 90,
            ),
          ],
        ));

  }
  Widget PageContent;

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
    setState(() {
      PageContent=PayWithOpetions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        children: [
          MasterTemplateWithoutFooter(

            // inProgress: _inprogress,
              wchild: Column(
                children: [
                  //    Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    'پرداخت قبوض',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: PColor.orangeparto,
                    thickness: 2,
                  ),
                  _payWithBarcode?
                      PayWithBarcode():
                      PayWithOpetions()
                  // بخش مربوط به اطلاعات اصلی
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
                      label: 'بعدی',
                      onClick: () {


                      //    _sendToPayment();

                      },
                      minWidth: 120,
                    ),
                    !_payWithBarcode?
                    CButton(
                      label: 'پرداخت با بارکد',
                      onClick: () {
                        scan();
                        setState(() {
                          _payWithBarcode=true;
                        });

                        },
                      minWidth: 120,
                    ):
                    CButton(
                      label: 'پرداخت عادی',
                      onClick: () {
                       // scan();
                        setState(() {
                          _payWithBarcode=false;
                        });

                      },
                      minWidth: 120,
                    ),

                  ],
                ),
              ),
            ),
          ),
         // _paymentDialog()
        ],
      )

    );
  }
}
