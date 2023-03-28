import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/model/user_model.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/app/landing/pages/landing_page.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  loginOnRegister(BuildContext context,
      {required String password, required User data}) async {
    emit(UserLogged(data));
    BlocProvider.of<ProfileCubit>(context)
        .fetchProfile(context, token: data.token);

    //create session
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', data.username);
    prefs.setString('pass', password);
    prefs.setString('token', data.token);

    String? token = await FirebaseMessaging.instance.getToken();
    print(token);

    final db = FirebaseFirestore.instance;

    db.collection('notif_token').doc('buyer_${data.id}').set({'token': token});

    Navigator.push(context, MaterialPageRoute(builder: (_) => LandingPage()));
  }

  loginSession(BuildContext context,
      {required String username, required String password}) {
    login(context, username: username, password: password, onSuccess: () {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LandingPage(),
        ),
      );
    }, onFailed: (val) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    });
  }

  login(BuildContext context,
      {required String username,
      required String password,
      required Function onSuccess,
      bool rememberMe = true,
      required Function(String?) onFailed}) async {
    AuthService.login(context, email: username, password: password)
        .then((value) async {
      if (value.status == RequestStatus.successRequest) {
        emit(UserLogged(value.data));

        User temp = value.data;

        BlocProvider.of<ProfileCubit>(context)
            .fetchProfile(context, token: temp.token);

        //create session
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', username);
        prefs.setString('pass', password);
        prefs.setString('token', temp.token);

        if (rememberMe) {
          prefs.setString('email_remember', username);
          prefs.setString('password_remember', password);
        } else {
          prefs.remove('email_remember');
          prefs.remove('password_remember');
        }

        String? token = await FirebaseMessaging.instance.getToken();
        print('token fcm dinisiiii');
        print(token);
        var dataFCM = jsonEncode({
          'user_id': temp.id,
          'cm_firebase_token': token,
        });
        var headerFCM = {
          //if header type is application/json then the data should be in jsonEncode method
          "Accept": "application/json",
          "Content-Type": "application/json"
        };

        http.post(Uri.parse('$baseApi/cm_firebase_token_update'),
            body: dataFCM, headers: headerFCM);

        onSuccess();
      } else {
        onFailed(value.data);
      }
    });
  }

  logout(BuildContext context) async {
    //create session
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(
      'email',
    );
    prefs.remove(
      'pass',
    );
    prefs.remove(
      'token',
    );
    FormHelper.showSnackbar(context,
        data: 'Berhasil Keluar', colors: Colors.green);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
  }
}
