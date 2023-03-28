import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/landing/pages/landing_page.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class LoginVM extends BaseViewModel {
  late bool passwordVisible = false;
  DateTime? currentBackPressTime;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool keepLoggedIn = false;
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  onBackPressed(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
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
  }

  onLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      BlocProvider.of<UserCubit>(context).login(context,
          username: emailController.text,
          password: passwordController.text, onSuccess: () {
        isLoading = false;
        notifyListeners();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LandingPage()));
      }, onFailed: (value) {
        isLoading = false;
        notifyListeners();
        FormHelper.showSnackbar(context,
            data: value ?? 'Gagal melakukan login', colors: Colors.orange);
      });
    }
  }

  passwordVisibleChanged() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  keepLoggedinChanged() {
    keepLoggedIn = !keepLoggedIn;
    notifyListeners();
  }

  onInit(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString('email_remember') != null) {
        emailController.text = prefs.getString('email_remember')!;
        passwordController.text = prefs.getString('password_remember')!;
        notifyListeners();
      }
    });
  }
}
