// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/app/splash/pages/intro_page.dart';
import 'package:qixer/shared/cubits/city_master/city_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SplashScreenVM extends BaseViewModel {
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

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

  Future displayNotification(
      BuildContext context, Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            playSound: true,
            // largeIcon: ,
            groupKey: 'type_a',
            color: Theme.of(context).primaryColor,
            enableVibration: true,
            importance: Importance.max,
            priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
        0,
        message['title'],
        message['body'],
        platformChannelSpecifics,
      );
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        0,
        message['aps']['alert']['title'],
        message['aps']['alert']['body'],
        platformChannelSpecifics,
      );
    }
  }

  onInit(BuildContext context) async {
    BlocProvider.of<CityCubit>(context).fetchCity(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString('email');
    if (email == null) {
      Future.delayed(const Duration(seconds: 2), () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool? resultIntro = prefs.getBool('intro');
        if (resultIntro == null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const IntroductionPage(),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        }
      });
    } else {
      String? email = prefs.getString('email');
      String? pass = prefs.getString('pass');

      BlocProvider.of<UserCubit>(context)
          .loginSession(context, username: email!, password: pass!);
    }
  }
}
