import 'package:flutter/material.dart';
import 'package:parto_v/Pages/OperativePages/Components/OperativePagesTemplate.dart';
import 'package:parto_v/UI/Colors.dart';
import 'package:parto_v/UI/Widgets/CButton.dart';
import 'package:parto_v/UI/Widgets/bubble.dart';
class ChargePage extends StatefulWidget {
  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  PageController _pageController;
  void _onSignUpButtonPress() {
    _pageController?.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
  void _onSignInButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    return OperativePagesTemplate(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),
          Text('شارژ تلفن همراه',style: Theme.of(context).textTheme.headline1,textAlign: TextAlign.center,),
          Text('اطلاعات مربوط به خرید شارژ را وارد کنید',style: Theme.of(context).textTheme.subtitle1,textAlign: TextAlign.center,),
          Divider(color: PColor.orangeparto,thickness: 2,),


          Expanded(child: ListView(
            padding: EdgeInsets.zero,
            children: [
/*
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: PColor.orangeparto,width: 2,style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: PColor.blueparto.shade100,
                      offset: Offset(0,0),
                      spreadRadius: 3,
                      blurRadius: 3,
                    )
                  ]
                ),
                height: 50.0,
                child:
                CustomPaint(
                  painter: TabIndicationPainter(pageController: _pageController),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                         onPressed: (){},
                          child: Text(
                            "مدیران",
                            style: TextStyle(
                                color: PColor.blueparto, fontSize: 16.0, fontFamily: "Samim"),
                          ),
                        ),
                      ),
                      //Container(height: 33.0, width: 1.0, color: Colors.white),
                      Expanded(
                        child: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                         onPressed: (){},
                          child: Text(
                            "مددکاران",
                            style: TextStyle(
                                color: PColor.blueparto, fontSize: 16.0, fontFamily: "Samim"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


              )
*/
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
                        ),
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.center,
                      )),
                      IconButton(icon: Icon(Icons.contact_page_rounded), onPressed: (){},color: PColor.blueparto,padding: EdgeInsets.all(3),)
                    ],
                  ),
                  Divider(color: Colors.white,thickness: 2,),
                  Text('در صورت ترابرد خط، اپراتور را تغییر دهید',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),textAlign: TextAlign.start,),




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
}
