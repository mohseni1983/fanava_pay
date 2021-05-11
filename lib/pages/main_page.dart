import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parto_v/Pages/donation.dart';
import 'package:parto_v/Pages/ghobooz.dart';
import 'package:parto_v/classes/profile.dart';
import 'package:parto_v/classes/topup.dart';
import 'package:parto_v/components/maintemplate.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
import 'package:parto_v/custom_widgets/cust_pre_invoice.dart';
import 'package:parto_v/pages/internet_package.dart';
import 'package:parto_v/pages/recipt.dart';
import 'package:parto_v/push_notifications.dart';
import 'package:parto_v/ui/cust_colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parto_v/classes/auth.dart' as auth;
import 'package:parto_v/classes/wallet.dart';
import 'charge.dart';
import 'package:uni_links/uni_links.dart';

class MainPage extends StatefulWidget {
  final FirebaseMessaging firebaseMessaging;

  const MainPage({Key key, this.firebaseMessaging}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}
enum UniLinksType { string, uri }

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
//  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //var pushNotificationService = PushNotificationService(_firebaseMessaging);
  String _latestLink = 'Unknown';

  Uri _latestUri;
  bool _hasMessage=false;

  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;
  initPlatformState() async {
    if (_type == UniLinksType.string)
      await initPlatformStateForStringUniLinks();

  }

  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
      debugPrint(_latestLink);
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }



  @override
  void didUpdateWidget(MainPage oldWidget) {
    setWalletAmount(this);
    setState(() {

    });
  }



  //final NavigationService _navigationService = locator<NavigationService>();
  @override
  void initState() {
    // TODO: implement initState

  //  pushNotificationService.initialise().then((value) => print(value));


    setWalletAmount(this);

    super.initState();

    Future.delayed(Duration(seconds: 2)).then((value) {
      widget.firebaseMessaging.configure(
        onBackgroundMessage: (Map<String,dynamic> message) async{
          setState(() {
            _hasMessage=true;
          });
        },
        onMessage: (Map<String, dynamic> message) async {
          // Navigator.of(context).pushNamed('/notifications');
          // Navigator.of(context).pushNamed('/notifications');
          //debugPrint('******************************************************////////////////////////******************************');
          showDialog(context: context, builder: (context) {
            return CAlertDialog(
              content: 'پیام جدید',
              subContent: 'پیام جدیدی دارید، آیا مشاهده می کنید؟',
              buttons: [
                CButton(
                  label: 'مشاهده',
                  onClick: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/notifications');
                  },
                ),
                CButton(
                  label: 'بستن',
                  onClick: (){
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },);
        },

        onLaunch: (Map<String, dynamic> message) async {
          //Navigator.of(context).pushNamed('/notifications');
          //debugPrint('******************************************************////////////////////////******************************');

          await Navigator.of(context).pushNamed('/notifications');
          //Navigator.of(context).pushNamed('/notifications');
/*          setState(() {
            _hasMessage=true;
          });*/
        },
        onResume: (Map<String, dynamic> message) async {
          await Navigator.of(context).pushNamed('/notifications');
          debugPrint('******************************************************////////////////////////******************************');

          //Navigator.of(context).pushNamed('/notifications');
          setState(() {
            _hasMessage=true;
          });
        },
      );

    });


    initPlatformState();

  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_latestLink);
    if(_latestLink!=null )
      if( !_latestLink.endsWith('Unknown') )
      {
        debugPrint(_latestLink);
        String link=_latestLink;
        _latestLink=null;
        return ReciptPage(url: link,);

      }

    return
      WillPopScope(
          child: MasterTemplate(
            hasMessage: _hasMessage,
              isHome: true,
              wchild: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                padding:
                EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 50),
                children: [
                  MainIcon(
                    label: 'شارژ سیم کارت',
                    image: AssetImage('assets/images/charge.png'),
                      onPress: ()=>Navigator.of(context).pushNamed('/charge')
                  ),
                  MainIcon(
                    label: 'بسته اینترنت',
                    image: AssetImage('assets/images/4GPackages.png'),
                    onPress: ()=>Navigator.of(context).pushNamed('/internet')
                  ),
                  MainIcon(
                    label: 'قبوض خدماتی',
                    image: AssetImage('assets/images/ghobooz3.png'),
                      onPress: ()=>Navigator.of(context).pushNamed('/bill')
                  ),
                  MainIcon(
                    label: 'نیکوکاری',
                    image: AssetImage('assets/images/donation2.png'),
                      onPress: ()=>Navigator.of(context).pushNamed('/donation')
                  ),




                ],
              )),
          onWillPop: () => _onWillPop())

    ;
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
            context: context,
            builder: (context) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: Text('آیا اطمینان دارید؟'),
                    content: Text('آیا می خواهید از اپ خارج شوید'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('خیر'),
                      ),
                      FlatButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text('بلی'),
                      ),
                    ],
                  ),
                )) ??
        false;
  }
}


class MainIcon extends StatefulWidget {
  final String label;
  final AssetImage image;
  final VoidCallback onPress;

  const MainIcon({Key key, this.label, this.image, this.onPress}) : super(key: key);
  @override
  _MainIconState createState() => _MainIconState();
}

class _MainIconState extends State<MainIcon> {
  @override
  Widget build(BuildContext context) {
    return                 GestureDetector(
      onTap: widget.onPress,
      child: Container(


          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.width/3,
                width: MediaQuery.of(context).size.width/3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:widget.image,
                      fit: BoxFit.contain

                  )
                ),
              ),
              Text('${widget.label}',style: TextStyle(color: PColor.blueparto),textScaleFactor: 1.1,),
            ],
          )
      ),
    );

  }
}



/*          Stack(
            children: [
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 10,left: 10),
                    height: MediaQuery.of(context).size.width/2.5,
                    width: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(
                      color: PColor.orangeparto,
                      borderRadius: BorderRadius.circular(15),

                    ),
                    child: Column(
                      children: [
                        Expanded(child: Container(height: 0,)),
                        Container(
                          margin: EdgeInsets.only(bottom: 5,left: 3,right: 3),
                          child:  Text('${widget.label}',style: TextStyle(color: PColor.blueparto),textScaleFactor: 1.1,),
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 0,
                  left: 0,

                  child: Container(
                    height: MediaQuery.of(context).size.width/3.1,
                    width: MediaQuery.of(context).size.width/3.1,
                    decoration: BoxDecoration(
                        color: PColor.blueparto.withAlpha(80),
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image:widget.image,
                            fit: BoxFit.contain
                        )

                    ),
                  )),
            ],

          )

*/