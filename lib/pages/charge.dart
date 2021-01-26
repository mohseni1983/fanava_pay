import 'package:flutter/material.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:group_button/group_button.dart';
import 'package:parto_v/ui/cust_colors.dart';



class ChargePage extends StatefulWidget {
  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  List<String> _selectedOperator=[];

  @override
  Widget build(BuildContext context) {
    return MasterTemplate(
      wchild:       Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),

          Text('شارژ تلفن همراه',style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.center,),
          Text('اطلاعات مربوط به خرید شارژ را وارد کنید',style: Theme.of(context).textTheme.subtitle1,textAlign: TextAlign.center,),
          Divider(color: PColor.orangeparto,thickness: 2,),


          Expanded(child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                  //padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    border: Border.all(color: PColor.orangeparto,style: BorderStyle.solid,width: 2),
                    borderRadius: BorderRadius.circular(25),
                    //color: Colors.white
                  ),
                  //height: 60.0,
                  margin: EdgeInsets.only(bottom: 5),
                child:                       Center(
                  child: GroupButton(
                    buttons: ['شارژ مستقیم','خرید کارت شارژ'],
                    isRadio: true,
                    spacing: 5,
                    onSelected: (index, isSelected) => print('$index button is selected'),
                    direction: Axis.horizontal,
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: PColor.blueparto,
                    unselectedColor: PColor.orangepartoAccent,
                    unselectedTextStyle: TextStyle(color: PColor.blueparto),
                  ),
                )
                ,
              ),

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
                    GroupButton(
                      direction: Axis.horizontal,
                        buttons: ['همراه اول','ایرانسل','رایتل'],
                        onSelected: (index, isSelected) => print('$index button is selected'),
                      isRadio: true,
                     // selectedButtons: _selectedOperator,
                      spacing: 2,
                      selectedColor: PColor.blueparto,
                      unselectedTextStyle: TextStyle(color: PColor.blueparto),



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
                    GroupButton(
                      direction: Axis.horizontal,
                      buttons: ['همراه اول','ایرانسل','رایتل'],
                      onSelected: (index, isSelected) => print('$index button is selected'),
                      isRadio: true,
                      // selectedButtons: _selectedOperator,
                      spacing: 2,
                      selectedColor: PColor.blueparto,
                      unselectedTextStyle: TextStyle(color: PColor.blueparto),



                    )




                  ],
                ),
              ),


              CButton(
                label: 'پرداخت',
                onClick: (){

                },
              )

            ],
          ))

        ],
      )

    );
  }

  _onPhoneChange(String number) {
    if(number.length>2){
      var _firstCharacter=number.substring(0,3);
      switch(_firstCharacter){
        case '091':
        case '099':
          {
            setState(() {
              _selectedOperator=['همراه اول'];

            });
            setState(() {

            });

          }
          break;
        case '093':
        case '094':
        {
          setState(() {
            _selectedOperator = ['ایرانسل'];
          });
          setState(() {

          });
        }
        break;
        case '092':
          {
            setState(() {
              _selectedOperator = ['رایتل'];
            });
            setState(() {

            });
          }
          break;
        default:
          {
            setState(() {
              _selectedOperator = [];
            });
            setState(() {

            });
          }
          break;





      }
    }
  }
}
