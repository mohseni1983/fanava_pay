import 'package:flutter/material.dart';
import 'package:parto_v/classes/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletWidget extends StatefulWidget {


  const WalletWidget({Key key}) : super(key: key);
  @override
  _WalletWidgetState createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> with TickerProviderStateMixin {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  double _walletAmount=0;
  bool _flag = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prefs.then((value) {
      if(value.containsKey('wallet_amount'))
        setState(() {
          _walletAmount=value.getDouble('wallet_amount');
        });
    });

  }
  @override
  Widget build(BuildContext context) {
    return
      Directionality(textDirection: TextDirection.rtl,
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.width/6,

                width: MediaQuery.of(context).size.width/6,

                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/wallet.png'),alignment: Alignment.center,fit: BoxFit.contain),

                ),

              ),
              Text('موجودی (تومان)',textScaleFactor: 0.8,),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(style: BorderStyle.solid,width: 2,color: Color.fromRGBO(224, 114, 67, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  /* boxShadow: [
                      BoxShadow(color: Color.fromRGBO(38, 63, 93, 1),offset: Offset(0,0),blurRadius: 3,spreadRadius: 3)
                    ],*/
                  color: Colors.white54,


                ),
                child: Row(
                  children: [
                    Expanded(child: Center(child: Text('${_walletAmount.toInt()}'),)),
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(224, 114, 67, 1),
                      radius: 13,


                      child: GestureDetector(
                        child: _flag?CircularProgressIndicator():Icon(Icons.refresh,color: Colors.white,size: 18,),
                        onTap: (){
                          setState(() {
                            _flag=true;
                            setState(() {

                            });
                          });
                          setWalletAmount().then((value) {
                            setState(() {
                              _flag=false;
                            });
                          });
                        },
                      )

                      //Icon(Icons.refresh,color: Colors.white,size: 18,),
                    )
                  ],
                ),
              )



            ],
          )


      );
  }

}

