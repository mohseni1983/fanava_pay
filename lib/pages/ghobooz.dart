import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan_fork/barcode_scan_fork.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parto_v/classes/wallet.dart';
import 'package:parto_v/components/maintemplate_withoutfooter.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_selectable_buttonbar.dart';
import 'package:parto_v/custom_widgets/cust_selectable_image_grid_btn.dart';
import 'package:parto_v/custom_widgets/cust_seletable_grid_item.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  bool _progressing = false;
  TextEditingController _billId=new TextEditingController();
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
  


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this._billId.text=barcode.substring(0,13);
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
          //Padding(padding: EdgeInsets.only(top: 20)),
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
                  Text('شناسه قبض:${_billId.text}'),
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

  int _selectedItem=-1;
  Widget PayWithOpetions(){
    return                   Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BillInfoWidget(_selectedItem),

            Container(height: 220,
            child: GridView.count(crossAxisCount: 5,
            mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: [
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/Ab-color.jpg',
                  grayImage: 'assets/images/logo/Ab-gray.jpg',
                  value: 1,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;

                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/gaz-color.jpg',
                  grayImage: 'assets/images/logo/gaz-gray.jpg',
                  value: 3,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;
                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/Bargh-color.jpg',
                  grayImage: 'assets/images/logo/Bargh-gray.jpg',
                  value: 2,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;
                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/mci-color.jpg',
                  grayImage: 'assets/images/mci-gray.jpg',
                  value: 5,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;
                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/mokhaberat-color.jpg',
                  grayImage: 'assets/images/logo/mokhaberat-grayr.jpg',
                  value: 4,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;
                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/maliat-color.jpg',
                  grayImage: 'assets/images/logo/maliat-gray.jpg',
                  value: 8,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;
                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/shahrdary-color.jpg',
                  grayImage: 'assets/images/logo/shahrdary-gray.jpg',
                  value: 7,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;


                    });
                  },
                ),
                CSeletableImageGridBtn(
                  colorImage: 'assets/images/logo/rahvar-color.jpg',
                  grayImage: 'assets/images/logo/rahvar-gray2.jpg',
                  value: 9,
                  selectedValue: _selectedItem,
                  onPress: (t){
                    setState(() {
                      _selectedItem=t;
                      _billId.text='';
                      _selectedOption=-1;

                    });
                  },
                ),




              ],


            ),
            ),
            Container(
              height: 90,
            ),
          ],
        ));

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


  int _selectedOption=-1;
  Widget BillInfoWidget(int selectedOption){
    switch(selectedOption){
      case 1:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شناسه قبض آب را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                          hintText: 'شناسه 14 رقمی'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 14,

                        controller: _billId,

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
                          MdiIcons.barcodeScan,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      scan();

                    },
                  )
                ],
              ),

            ],
          ),
        );
        break;
      case 2:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شناسه قبض برق را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'شناسه 14 رقمی'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 14,

                        controller: _billId,

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
                          MdiIcons.barcodeScan,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      scan();

                    },
                  )
                ],
              ),

            ],
          ),
        );
        break;
      case 3:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شناسه قبض گاز را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'شناسه 14 رقمی'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 14,

                        controller: _billId,

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
                          MdiIcons.barcodeScan,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      scan();

                    },
                  )
                ],
              ),

            ],
          ),
        );
        break;
      case 4:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شماره تلفن ثابت با کد شهر را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'مثال:02187654321'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 11,

                        controller: _billId,

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
                          MdiIcons.contacts,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      getContact().then((value) {
                        setState(() {
                          _billId.text=value;
                        });
                      });

                    },
                  )
                ],
              ),
              Row(
                children: [
                  CSelectedButton(
                    height: 40,
                    selectedValue: _selectedOption,
                    value: 1,
                    label: 'میان دوره',
                    onPress: (t){
                      setState(() {
                        _selectedOption=t;
                      });
                    },
                  ),
                  CSelectedButton(
                    height: 40,
                    selectedValue: _selectedOption,
                    value: 2,
                    label: 'پایان دوره',
                    onPress: (t){
                      setState(() {
                        _selectedOption=t;
                      });
                    },
                  )


                ],
              )

            ],
          ),
        );
        break;
      case 5:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شماره تلفن همراه را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'مثال:09123456789'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 11,

                        controller: _billId,

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
                          MdiIcons.contacts,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      getContact().then((value) {
                        setState(() {
                          _billId.text=value;
                        });
                      });

                    },
                  )
                ],
              ),
              Row(
                children: [
                  CSelectedButton(
                    height: 40,
                    selectedValue: _selectedOption,
                    value: 1,
                    label: 'میان دوره',
                    onPress: (t){
                      setState(() {
                        _selectedOption=t;
                      });
                    },
                  ),
                  CSelectedButton(
                    height: 40,
                    selectedValue: _selectedOption,
                    value: 2,
                    label: 'پایان دوره',
                    onPress: (t){
                      setState(() {
                        _selectedOption=t;
                      });
                    },
                  )


                ],
              )

            ],
          ),
        );
        break;
      case 6:
      case 7:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شناسه قبض عوارض شهرداری را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'شناسه 14 رقمی'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 14,

                        controller: _billId,

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
                          MdiIcons.barcodeScan,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      scan();

                    },
                  )
                ],
              ),

            ],
          ),
        );
        break;
      case 8:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شناسه قبض مالیات را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'شناسه 14 رقمی'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 14,

                        controller: _billId,

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
                          MdiIcons.barcodeScan,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      scan();

                    },
                  )
                ],
              ),

            ],
          ),
        );
        break;
      case 9:
        return Container(
          decoration: BoxDecoration(
            color: PColor.orangepartoAccent,
            border: Border.all(color: PColor.orangeparto,width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(3),
          child: Column(
            children: [
              Text('شناسه قبض جریمه رانندگی را وارد کنید'),
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
                              MdiIcons.label,
                              color: PColor.orangeparto,
                            ),
                            fillColor: Colors.white,
                            counterText: '',
                            hintText: 'شناسه 14 رقمی'
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 14,

                        controller: _billId,

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
                          MdiIcons.barcodeScan,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    onTap: () {
                      scan();

                    },
                  )
                ],
              ),

            ],
          ),
        );
        break;



      default:
        return Container(height: 0,);
        break;




    }

  }

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
  }

  String createBillData(){
    switch(_selectedItem){
      case 1:
      case 2:
      case 3:
      case 6:
      case 7:
      case 8:
      case 9:
        {
        if(_billId.text.isEmpty || _billId.text.length<13)
          {
            showDialog(context: context,
              builder: (context) => CAlertDialog(
                content: 'خطا در شناسه',
                subContent: 'شناسه قبض صحیح نیست',
                buttons: [CButton(
                  label: 'بستن',
                  onClick: ()=>Navigator.of(context).pop(),
                )],
              ),
            );
            return '';

          }
        else
          return '$_selectedItem,${_billId.text}';
        break;
      }
      case 4:
        if(_billId.text.isEmpty || _billId.text.length<11 || !_billId.text.startsWith('0'))
          {
            showDialog(context: context,
              builder: (context) => CAlertDialog(
                content: 'خطا در شماره',
                subContent: 'شماره تلفن صحیح نیست',
                buttons: [CButton(
                  label: 'بستن',
                  onClick: ()=>Navigator.of(context).pop(),
                )],
              ),
            );
            return '';

          }
        else if(_selectedOption<1)
          {
            showDialog(context: context,
              builder: (context) => CAlertDialog(
                content: 'خطا در انتخاب دوره',
                subContent: 'یک دوره را برای قبض انتخاب کنید',
                buttons: [CButton(
                  label: 'بستن',
                  onClick: ()=>Navigator.of(context).pop(),
                )],
              ),
            );
            return '';

          }
        else

        return '4,${_billId.text},${_selectedOption}';
        break;
      case 5:
        if(_billId.text.isEmpty || _billId.text.length<11 || !_billId.text.startsWith('09'))
          {
            showDialog(context: context,
              builder: (context) => CAlertDialog(
                content: 'خطا در شماره',
                subContent: 'شماره همراه صحیح نیست',
                buttons: [CButton(
                  label: 'بستن',
                  onClick: ()=>Navigator.of(context).pop(),
                )],
              ),
            );
            return '';

          }
        else if(_selectedOption<1)
          {
            showDialog(context: context,
              builder: (context) => CAlertDialog(
                content: 'خطا در انتخاب دوره',
                subContent: 'یک دوره را برای قبض انتخاب کنید',
                buttons: [CButton(
                  label: 'بستن',
                  onClick: ()=>Navigator.of(context).pop(),
                )],
              ),
            );
            return '';

          }
        else

          return '5,${_billId.text},${_selectedOption}';
        break;




      default:
        showDialog(context: context,
          builder: (context) => CAlertDialog(
            content: 'خطا در انتخاب',
            subContent: 'یک قبض را برای پرداخت انتخاب کنید',
            buttons: [CButton(
              label: 'بستن',
              onClick: ()=>Navigator.of(context).pop(),
            )],
          ),
        );
        return '';
        break;

    }
  }

  Future<void> getBillInfo(){
    String _billInfo=createBillData();
    if(_billInfo.isNotEmpty)
     {
       setState(() {
         //  _readyToPay = false;
         _progressing = true;
       });

       auth.checkAuth().then((value) async {
         if (value) {
           SharedPreferences _prefs = await SharedPreferences.getInstance();
           String _token = _prefs.getString('token');
           var _body = {
             "BillData": _billInfo,
             "LocalDate": DateTime.now().toString(),
             "Sign": _prefs.getString('sign'),
             "UseWallet": true
           };
           var jBody = json.encode(_body);

           var result = await http.post(
               'https://www.idehcharge.com/Middle/Api/Charge/BillInquiry',
               headers: {
                 'Authorization': 'Bearer $_token',
                 'Content-Type': 'application/json'
               },
               body: jBody);
           if (result.statusCode == 401) {
             auth.retryAuth().then((value) {
               getBillInfo();
             });
           }
           if (result.statusCode == 200) {
             setState(() {
               _progressing = false;
             });

             await setWalletAmount();
             setState(() {

             });
             var jres = json.decode(result.body);
             debugPrint('==========================================================================');
             debugPrint(jres.toString());
             debugPrint('==========================================================================');

/*             if (jres["ResponseCode"] == 0)
               showDialog(
                 context: context,
                 builder: (context) => CAlertDialog(
                   content: 'عملیات موفق',
                   subContent: 'شارژ و پرداخت از کیف پول با موفقیت انجام شد',
                   buttons: [
                     CButton(
                       label: 'بستن',
                       onClick: () => Navigator.of(context).pop(),
                     )
                   ],
                 ),
               );
             else
               showDialog(
                 context: context,
                 builder: (context) => CAlertDialog(
                   content: 'عملیات ناموفق',
                   subContent: jres['ResponseMessage'],
                   buttons: [
                     CButton(
                       label: 'بستن',
                       onClick: () => Navigator.of(context).pop(),
                     )
                   ],
                 ),
               );*/
           }
         }
       });
     }

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
                  Padding(padding: EdgeInsets.only(top: 10)),
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
                      PayWithOpetions(),
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
                        if(!_payWithBarcode)
                          getBillInfo();


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
                          _billId.text='';

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
                          _billId.text='';

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
