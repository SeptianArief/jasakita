import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qixer/app/splash/vm/splash_screen_vm.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  // late FirebaseMessaging messaging;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     new FlutterLocalNotificationsPlugin();

  Future onDidRecieveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => new CupertinoAlertDialog(
    //     title: new Text(title!),
    //     content: new Text(body!),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: new Text('Ok'),
    //         onPressed: () async {
    //           Navigator.pop(context);
    //           await Fluttertoast.showToast(
    //               msg: "Notification Clicked",
    //               toastLength: Toast.LENGTH_SHORT,
    //               gravity: ToastGravity.BOTTOM,
    //               backgroundColor: Colors.black54,
    //               textColor: Colors.white,
    //               fontSize: 16.0);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      print('Payload Notification: $payload');
    }
  }

  Future displayNotification(Map<String, dynamic> message) async {
    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //     'your channel id', 'your channel name',
    //     playSound: true,
    //     groupKey: 'type_a',
    //     color: Theme.of(context).primaryColor,
    //     enableVibration: true,
    //     importance: Importance.max,
    //     priority: Priority.high);
    // var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics,
    //     iOS: iOSPlatformChannelSpecifics);
    // if (Platform.isAndroid) {
    //   // fToast.showToast(
    //   //   child: SuccessToast.notificationToast(context,
    //   //       title: message['title'], description: message['body']),
    //   //   gravity: ToastGravity.TOP,
    //   //   toastDuration: Duration(seconds: 3),
    //   // );
    //   await flutterLocalNotificationsPlugin.show(
    //     0,
    //     message['title'],
    //     message['body'],
    //     platformChannelSpecifics,
    //   );
    // } else if (Platform.isIOS) {
    //   await flutterLocalNotificationsPlugin.show(
    //     0,
    //     message['aps']['alert']['title'],
    //     message['aps']['alert']['body'],
    //     platformChannelSpecifics,
    //   );
    // }
  }

  @override
  void initState() {
    // var initializationSettingsAndroid =
    //     const AndroidInitializationSettings('app_icon');

    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);

    // messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   print(value);
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   displayNotification({
    //     'title': event.notification!.title,
    //     'body': event.notification!.body
    //   });
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashScreenVM>.reactive(viewModelBuilder: () {
      return SplashScreenVM();
    }, onViewModelReady: (model) {
      model.onInit(context);
    }, builder: (context, model, child) {
      return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xffDF10D2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fitHeight)),
                ),
                const SizedBox(
                  height: 15,
                ),
                showLoading(Theme.of(context).primaryColor)
              ],
            ),
          ));
    });
  }
}
