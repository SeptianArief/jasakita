import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qixer/app/account/pages/account_page.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/home/pages/home_page.dart';
import 'package:qixer/app/landing/widgets/bottom_nav_landing.dart';
import 'package:qixer/app/new_service/pages/new_service_page.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/pages/order_list_page.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/push_notif_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class LandingPage extends StatefulWidget {
  final int initialPage;
  const LandingPage({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<LandingPage> {
  int _currentIndex = 0;
  //Bottom nav pages
  late List<Widget> children;
  late FirebaseMessaging messaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    children = [
      HomePage(),
      OrdersPage(orderCubit: orderCubit),
      NewestTab(),
      MenuPage(),
    ];

    if (widget.initialPage == 1) {
      onTabTapped(1);
    }

    super.initState();
    initPusherBeams(context);
  }

  DateTime? currentBackPressTime;
  OrderCubit orderCubit = OrderCubit();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 1) {
        orderCubit.fetchOrder(context);
      }

      if (index == 3) {}
      UserState userState = BlocProvider.of<UserCubit>(context).state;
      if (userState is UserLogged) {
        BlocProvider.of<ProfileCubit>(context)
            .fetchProfile(context, token: userState.user.token, refresh: true);
      }
    });
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

  //Notification alert
  //=================>
  initPusherBeams(BuildContext context) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print('token FCM');
      print(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      displayNotification(context, {
        'title': event.notification!.title,
        'body': event.notification!.body,
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: () {
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) {
              currentBackPressTime = now;
              FormHelper.showSnackbar(context,
                  data: 'Tekan sekali lagi untuk keluar', colors: Colors.black);

              return Future.value(false);
            }
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
            return Future.value(true);
          },
          child: IndexedStack(
            children: children,
            index: _currentIndex,
          )),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
