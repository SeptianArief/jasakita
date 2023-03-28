import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  const BottomNav(
      {Key? key, required this.currentIndex, required this.onTabTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: mainFont.copyWith(fontSize: 12),
        selectedItemColor: ConstantColors().primaryColor,
        unselectedItemColor: ConstantColors().greyFour,
        onTap: onTabTapped, // new
        currentIndex: currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/home-icon.svg',
                  color: currentIndex == 0 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/orders-icon.svg',
                  color: currentIndex == 1 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Pesanan',
          ),
          // BottomNavigationBarItem(
          //   icon: Container(
          //     margin: const EdgeInsets.only(bottom: 6),
          //     child: SvgPicture.asset('assets/svg/saved-icon.svg',
          //         color: currentIndex == 2 ? cc.primaryColor : cc.greyFour,
          //         semanticsLabel: 'Acme Logo'),
          //   ),
          //   label: 'Saved',
          // ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/search-icon.svg',
                  color: currentIndex == 2 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Jasa Terbaru',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: SvgPicture.asset('assets/svg/settings-icon.svg',
                  color: currentIndex == 3 ? cc.primaryColor : cc.greyFour,
                  semanticsLabel: 'Acme Logo'),
            ),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
