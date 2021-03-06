import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:fanava_payment/classes/convert.dart';
import 'package:fanava_payment/classes/recipt.dart';
import 'package:fanava_payment/custom_widgets/cust_button.dart';
import 'package:fanava_payment/pages/main_page.dart';
import 'package:fanava_payment/pages/transactions.dart';
import 'package:fanava_payment/ui/cust_colors.dart';
import 'package:share/share.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class ReciptPage extends StatefulWidget {
  final String url;
  

  const ReciptPage({Key key, this.url}) : super(key: key);
  @override
  _ReciptPageState createState() => _ReciptPageState();
}

class _ReciptPageState extends State<ReciptPage> {
  Recipt _recipt=new Recipt();
  GlobalKey _globalKey = new GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      //print('inside');
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 6.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    setState(() {
     _recipt=reciptFromJson(Uri.decodeComponent(widget.url.replaceAll('partov://idehcharge.com?transactiondata=', '')));
      debugPrint(widget.url);
     // debugPrint(Uri.decodeComponent(widget.url.replaceAll('partov://idehcharge.com?transactiondata=', '')));
    });
  }
  bool _progressing = false;

  Widget Progress() => Material(
    color: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: PColor.orangeparto.shade200,
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

  TransactionType getTransactionType(int id){
    switch(id){
      case 6:
        return TransactionType(color: Colors.blue,name: '???????? ?????? ??????');
        break;
      case 0:
        return TransactionType(color: Colors.green,name: '???????? ????????????');
        break;
      default:
        return TransactionType(color: PColor.blueparto,name: '???????????? ?????? $id');
        break;
    }
  }

  String getOrg(int id){
    switch(id){
      case 1:
        return '?????? ????';
        break;
      case 3:
        return '?????? ??????';
        break;
      case 2:
        return '?????? ??????';
        break;
      case 4:
        return '?????? ???????? ????????';
        break;
      case 5:
        return '?????? ???????? ??????????';
        break;
      case 6:
      case 7:
        return '?????? ?????????? ??????????????';
        break;
      case 8:
        return '?????? ????????????';
        break;
      case 9:
        return '?????? ?????????? ??????????????';
        break;
      default:
        return '???????? ????????';
        break;


    }
  }

  List<Widget> _info(int resp){
    switch(resp){
      case 0:
        return [
          RepaintBoundary(
            key: _globalKey,
            child:
            Container(
              padding: EdgeInsets.fromLTRB(5, 35, 5, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: PColor.orangeparto.shade200,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          alignment: Alignment.center,

                        )
                    ),
                  ),
                  Text('???????????????? ???????????? ????????',style: TextStyle(color: PColor.blueparto,fontSize: 22,fontWeight: FontWeight.w900),),
                  Divider(indent: 5,endIndent: 5,thickness: 1,height: 3,),
                  Text('???????? ?????????? ???????????? ????????????????',style: TextStyle(color: PColor.blueparto,fontSize: 16,fontWeight: FontWeight.w700),),
                  Divider(indent: 5,endIndent: 5,thickness: 2,height: 3,),
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('?????? ????????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${getTransactionType(int.parse(_recipt.requestType)).name}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                      ],
                    ),
                  ),
                  int.parse(_recipt.requestType)==0?
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('?????????? ??????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${_recipt.cellNumber}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                      ],
                    ),
                  ):
                  Container(height: 0,),
                  int.parse(_recipt.billGroup)!=0?
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('?????? ??????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${getOrg(int.parse(_recipt.billGroup))}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                      ],
                    ),
                  ):
                  Container(height: 0,),




                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${getMoneyByRial(int.parse(_recipt.amount)) } ????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('?????????? ??????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${_recipt.datePaid}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),textDirection: TextDirection.ltr,),

                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('?????????? ????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${_recipt.cardNumber}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),textDirection: TextDirection.ltr,),

                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('????????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${_recipt.traceNumber}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                      ],
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(4),
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: PColor.orangepartoAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('?????????? ????????????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),
                        Text('${_recipt.invoiceId}',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                      ],
                    ),
                  ),
                  Container(
                      padding:EdgeInsets.all(4),
                      margin: EdgeInsets.all(2),
                      //height: 80,
                      decoration: BoxDecoration(
                          color: PColor.orangepartoAccent,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('??????',style: TextStyle(color: PColor.blueparto,fontSize: 14,fontWeight: FontWeight.w900),),

                            ],
                          ),
                          Text('${_recipt.description}',style: TextStyle(color: PColor.blueparto,fontSize: 11,fontWeight: FontWeight.w900),softWrap: true,),


                        ],
                      )
                  ),


                ],
              ),

            ),


          ),
          Positioned(

              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: PColor.blueparto,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12))
                ),

                height: 60,width: MediaQuery.of(context).size.width-20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    CButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        label: '???????????? ?????????? ??????????',
                        onClick: () {
                          ShareFilesAndScreenshotWidgets().shareScreenshot(
                              _globalKey,
                              800,
                              "Title",
                              "Name.png",
                              "image/png",
                              text: "???????? ???????????? ????????");
                        }
/*                            async{
                              _capturePng().then((value) async {
                                var path=await ImagePickerSaver.saveFile(fileData: value.buffer.asUint8List());
                                Share.shareFiles([path]);
                              });
                            },*/
                    ),
                    CButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      label: '???????????? ?????????? ??????',
                      onClick: (){
                        var _msg='???????????????? ???????? ????????????' +'\r\n';
                        _msg+='????????: ${getMoneyByRial(int.parse(_recipt.amount))}????????'+'\r\n';
                        _msg+='??????????: ${_recipt.datePaid}'+'\r\n';
                        _msg+='????????: ${_recipt.cardNumber}'+'\r\n';
                        _msg+='????????????: ${_recipt.traceNumber}'+'\r\n';
                        Share.share(_msg);



                      },
                    )

                  ],),

              )
          ),
        ];
        break;
      case -1:
        return [
          Text('???????????? ???????? ?????????? ?????? ????.')
        ];
        break;
      default:
        return [
          Text('?????????? ???? ???????????? ???? ???????? ??????.')
        ];



    }
  }





  Widget build(BuildContext context) {
    return 
        WillPopScope(child:       
        Directionality(textDirection: TextDirection.rtl, child: Scaffold(
          body:
                      Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child:                   Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _info(int.parse(_recipt.respCode)),
                    ),
                  ),


                  Positioned(
                      top: 50,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close,color: Colors.black,size: 40,),
                        onPressed: ()=>Navigator.of(context).pop(),
                      )),

                  _progressing?Progress():Container(height: 0,)

                ],
              )



        )
        ),
          onWillPop: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage(),)),
    );
  }
}




