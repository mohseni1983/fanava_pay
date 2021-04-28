import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  BuildContext get context => null;

  Future<String> initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

/*
    Future<String> getToken() async{
      return await _fcm.getToken();
    }
*/

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // Navigator.of(context).pushNamed('/notifications');
        debugPrint('hi:'+message.toString());
      },
      onLaunch: (Map<String, dynamic> message) async {
        debugPrint('hi:'+message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        debugPrint('hi:'+message.toString());
      },
    );
    print(token);
    return token;

  }
}
/*
class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String,dynamic> message) async{
          print('on message : $message');
        }


    );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      _initialized = true;
    }
  }
}*/
