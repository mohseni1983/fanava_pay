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

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _billId = barcodeScanRes;
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
                  // بخش مربوط به اطلاعات اصلی
                  Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
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
                                     onTap: () =>scanBarcodeNormal()
                                   )
                                  ],
                                )
                              ],
                            ),
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
                      label: 'بعدی',
                      onClick: () {


                      //    _sendToPayment();

                      },
                      minWidth: 120,
                    ),
                    CButton(
                      label: 'تکرار خرید قبلی',
                      onClick: () {},
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
