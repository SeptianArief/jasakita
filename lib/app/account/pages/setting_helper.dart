import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsHelper {
  ConstantColors cc = ConstantColors();
  borderBold(double marginTop, double marginBottom) {
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      child: Divider(
        height: 0,
        thickness: 4,
        color: cc.borderColor,
      ),
    );
  }

  List<SettingsGridCard> cardContent = [
    SettingsGridCard('assets/svg/pending-circle.svg', 'Pending'),
    SettingsGridCard('assets/svg/active-circle.svg', 'Pesanan Aktif'),
    SettingsGridCard('assets/svg/completed-circle.svg', 'Pesanan Selesai'),
    SettingsGridCard('assets/svg/receipt-circle.svg', 'Total Pesanan'),
  ];

  settingOption(String icon, String title, VoidCallback pressed) {
    return ListTile(
      onTap: pressed,
      leading: SvgPicture.asset(
        icon,
        height: 35,
      ),
      title: Text(
        title,
        style: mainFont.copyWith(color: cc.greyFour, fontSize: 14),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 17,
      ),
    );
  }

  logoutPopup(BuildContext context) {
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
            children: [
              Text(
                'Apakah Anda yakin?',
                style: mainFont.copyWith(color: cc.greyPrimary, fontSize: 17),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                      child: CommonHelper().borderButtonOrange('Batal', () {
                    Navigator.pop(context);
                  })),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: CommonHelper().buttonOrange('Keluar', () {
                    BlocProvider.of<UserCubit>(context).logout(context);
                  }, isloading: false)),
                ],
              )
            ],
          ),
        )).show();
  }
}

class SettingsGridCard {
  String iconLink;
  String text;

  SettingsGridCard(this.iconLink, this.text);
}
