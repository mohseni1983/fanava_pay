import 'package:flutter/material.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:group_button/group_button.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';



class ChargePage extends StatefulWidget {
  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  TextEditingController _mobile= new TextEditingController();
  int _topUpOperator=0;


  List<OperatorsWithLogo> _operatorsWithLogo=[
    new OperatorsWithLogo(id: 0,name: 'ایرانسل',colorImage: 'assets/images/mtn-color.jpg',grayImage: 'assets/images/mtn-gray.jpg'),
    new OperatorsWithLogo(id: 1,name: 'همراه اول',colorImage: 'assets/images/mci-color.jpg',grayImage: 'assets/images/mci-gray.jpg'),
    new OperatorsWithLogo(id:3,name: 'رایتل',colorImage: 'assets/images/rightel-color.jpg',grayImage: 'assets/images/rightel-gray.jpg'),
    new OperatorsWithLogo(id:4,name: 'شاتل موبایل',colorImage: 'assets/images/shatel-color.jpg',grayImage: 'assets/images/shatel-gray.jpg')
  ];



  void _sendToPayment(){

    TopUp _current= new TopUp();
    _prefs.then((value) {
      _current.sign=value.getString('sign');
      _current.amount=_selectedAmount;
      _current.chargeType=0;
      _current.cellNumber=_mobile.text.substring(1,11);
      _current.deviceId=0;
      _current.useWallet=false;
      _current.localDate=DateTime.now();
      _current.topUpOperator=_topUpOperator;
      _current.uniqCode="";
    }).then((value) {
    showDialog(
      context: context,
      builder: (context) => PreInvoice(paymentType: paymentTypes.Charge,paymentInfo: _current,));
    });


  }

  TopUp _generatePaymentInfo() {
    TopUp _current= new TopUp();
    _prefs.then((value) {
      _current.sign=value.getString('sign');
      _current.amount=_selectedAmount;
      _current.chargeType=0;
      _current.cellNumber=_mobile.text.substring(1,11);
      _current.deviceId=0;
      _current.useWallet=false;

      _current.localDate=DateTime.now();
      _current.topUpOperator=_topUpOperator;
      _current.uniqCode="";
    }).then((value) { return _current;});

  }



  List<String> _selectedOperator=[];
  List<String> _chargeTypes=[
    'شارژ مستقیم',
    'کارت شارژ'
  ];
  List<int> _charges=[20000,50000,100000,200000];
  int _selectedAmount=0;
  int _selectedChargeType=0;

  @override
  Widget build(BuildContext context) {
    return MasterTemplate(
      wchild:       Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),

          Text('شارژ تلفن همراه',style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.center,),
          Text('اطلاعات مربوط به خرید شارژ را وارد کنید',style: Theme.of(context).textTheme.subtitle1,textAlign: TextAlign.center,),
          Divider(color: PColor.orangeparto,thickness: 2,),


          Expanded(child:
              Center(
                child:           ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      //padding: EdgeInsets.all(7),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: PColor.orangeparto,style: BorderStyle.solid,width: 2),
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.white
                      ),
                      height: 50.0,
                      // width: MediaQuery.of(context).size.width-100,
                      margin: EdgeInsets.only(bottom: 5),
                      child:     GridView.builder(
                        padding: EdgeInsets.zero,
                        //scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4
                        ),


                        itemCount: _chargeTypes.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child:
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width/2.3,
                              margin: EdgeInsets.fromLTRB(1, 4, 1, 4),
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: _selectedChargeType==index?PColor.blueparto:PColor.orangeparto,
                              ),
                              child: Center(
                                child: Text('${_chargeTypes[index]}',style: TextStyle(color: _selectedChargeType==index?Colors.white:PColor.blueparto,),),
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                _selectedChargeType=index;
                              });
                            },

                          )
                          ;
                        },
                      ),

                    )


                    ,

                    Container(
                      decoration: BoxDecoration(
                        color: PColor.orangeparto,
                        borderRadius: BorderRadius.circular(10),


                      ),
                      padding: EdgeInsets.all(5),
                      child: Column(

                        children: [
                          Text('شماره همراه مورد نظر را وارد و یا از دفترچه تلفن انتخاب کنید',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),textAlign: TextAlign.center,),
                          Row(
                            children: [
                              Expanded(child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 2,


                                  ),

                                  suffixIcon: Icon(Icons.sim_card,color: PColor.orangeparto,),
                                  fillColor: Colors.white,
                                  counterText: '',
                                  // hintText: '09123456789'

                                ),
                                keyboardType: TextInputType.phone,
                                maxLength: 11,
                                controller: _mobile,
                                onChanged: (v){
                                  if(v.isNotEmpty && v.length==3){
                                    _onPhoneChange(v);
                                  }
                                },
                                textAlign: TextAlign.center,
                              )),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: PColor.blueparto,
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: Center(
                                    child: Icon(Icons.contact_page_rounded,color: Colors.white,size: 35,),
                                  ),
                                ),
                                onTap: (){},
                              )
                            ],
                          ),
                          Divider(color: Colors.white,thickness: 2,),
                          Text('در صورت ترابرد خط، اپراتور را تغییر دهید',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),textAlign: TextAlign.start,),
/*
                          GroupButton(
                            direction: Axis.horizontal,
                            buttons: ['ایرانسل','همراه اول','رایتل','شاتل موبایل'],
                            onSelected: (index, isSelected) {
                              setState(() {
                                _topUpOperator=index;
                              });
                            },
                            isRadio: true,
                            // selectedButtons: _selectedOperator,
                            spacing: 2,
                            selectedColor: PColor.blueparto,
                            unselectedTextStyle: TextStyle(color: PColor.blueparto),



                          )
*/
                            Container(
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _operatorsWithLogo.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(color: index==_topUpOperator?PColor.orangeparto:Colors.grey,width: 1),
                                        image: DecorationImage(
                                          image: AssetImage(index==_topUpOperator?_operatorsWithLogo[index].colorImage:_operatorsWithLogo[index].grayImage),
                                          fit: BoxFit.fill,
                                        )

                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        _topUpOperator=index;
                                      });
                                    },
                                  );
                                },
                              ),

                            )



                        ],
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: PColor.orangeparto,width: 2)



                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top: 5),
                      height: 170,
                      child: Column(

                        children: [
                          Text('مبلغ شارژ را مشخص کنید',style: TextStyle(color: PColor.blueparto,fontWeight: FontWeight.normal,fontSize: 12),textAlign: TextAlign.center,),
                          Divider(color: PColor.orangeparto,thickness: 2,),

                          Expanded(child: GridView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _charges.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _selectedAmount=_charges[index];
                                  });
                                },
                                child:
                                Container(
                                  decoration: BoxDecoration(
                                      color: _charges[index]==_selectedAmount? PColor.blueparto:PColor.orangeparto,
                                      borderRadius: BorderRadius.circular(8)

                                  ),
                                  height: 70,
                                  //width: 70,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  child: Center(
                                    child: Text('${_charges[index]} ریال ',style: TextStyle(color:_charges[index]==_selectedAmount?  Colors.white:PColor.blueparto),),
                                  ),
                                )
                                ,
                              );
                            },

                          ))
/*
                    SmartSelect.single(
                        choiceItems: [
                          S2Choice(value: 1, title: '10,000'),
                          S2Choice(value: 2, title: '20,000'),
                          S2Choice(value: 3, title: '50,000'),
                          S2Choice(value: 4, title: '100,000',),

                        ],
                        value: _chargeValue, onChange: (val){
                          debugPrint(val.value.toString());
                    },
                      title: 'انتخاب شارژ',
                      modalType: S2ModalType.bottomSheet,

                    )
*/




                        ],
                      ),
                    ),


                    CButton(
                      label: 'پرداخت',
                      onClick: (){
                        if(_mobile.text.length==11 && _mobile.text.startsWith('09')){

                          _sendToPayment();

                        }else{
                          showDialog(context: context,
                            builder: (context) => CAlertDialog(content: 'شماره موبایل وارد شده صحیح نیست',buttons: [CButton(label: 'اصلاح',onClick: ()=>Navigator.of(context).pop(),)],),
                          );
                        }

                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 100)),

                  ],
                )
                ,
              )
          )

        ],
      )

    );
  }

  List<int> _chargeValue=[1];

  _onPhoneChange(String number) {
    if(number.length>2){
      var _firstCharacter=number.substring(0,3);
      switch(_firstCharacter){
        case '091':
          {
            setState(() {
              _topUpOperator=1;

            });
            setState(() {

            });

          }
          break;
        case '093':
        case '094':
        {
          setState(() {
            _topUpOperator=0;
          });
          setState(() {

          });
        }
        break;
        case '092':
          {
            setState(() {
              _topUpOperator=2;
            });
            setState(() {

            });
          }
          break;
        case '099':
          {
            setState(() {
              _topUpOperator=3;
            });
            setState(() {

            });
          }
          break;

        default:
          {
            setState(() {
              _topUpOperator=-1;
            });
            setState(() {

            });
          }
          break;





      }
    }
  }
}


class OperatorsWithLogo{
  int id;
  String name;
  String grayImage;
  String colorImage;

  OperatorsWithLogo({this.id, this.name, this.grayImage, this.colorImage});
}


