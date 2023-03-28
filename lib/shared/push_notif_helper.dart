import 'package:flutter/material.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class PushNotificationHelper {
  final cc = ConstantColors();

  //Popup
//=============>
  notificationAlert(BuildContext context, title, desc) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: mainFont.copyWith(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: mainFont.copyWith(color: cc.greyPrimary, fontSize: 16),
              ),
              SizedBox(height: 7),
              Text(
                "$desc",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: mainFont.copyWith(color: cc.greyPrimary, fontSize: 14),
              ),
              const SizedBox(
                height: 25,
              ),
              CommonHelper().buttonOrange('Ok', () {
                Navigator.pop(context);
              }),
            ],
          ),
        )).show();
  }
}
