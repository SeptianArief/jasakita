import 'package:flutter/material.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class IntroVM extends BaseViewModel {
  ConstantColors cc = ConstantColors();
  int selectedSlide = 0;
  final PageController pageController = PageController();

  onChangePage(int value) {
    selectedSlide = value;
    notifyListeners();
  }

  onNext(BuildContext context) async {
    if (selectedSlide == 2) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('intro', true);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      pageController.animateToPage(selectedSlide + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      selectedSlide = selectedSlide + 1;
      notifyListeners();
    }
  }

  getImage(int i) {
    return 'assets/images/intro${i + 1}.png';
  }

  geTitle(int i) {
    List title = [
      "Jasa Home Service di Indonesia",
      "Jasa Home Service Lengkap",
      "Vendor Berpengalaman"
    ];
    return title[i];
  }

  geSubTitle(int i) {
    List subTitle = [
      "Dapatkan jasa home service di seluruh wilayah Indonesia",
      "Pilihan jasa home service sesuai kebutuhan rumah anda",
      "Vendor Jasakita  berkualitas baik yang ahli dibidangnya"
    ];
    return subTitle[i];
  }
}
