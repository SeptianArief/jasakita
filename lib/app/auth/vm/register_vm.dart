import 'package:flutter/material.dart';
import 'package:qixer/app/auth/pages/otp_verification_page.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/shared/cubits/area_master/area_cubit.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:stacked/stacked.dart';

class RegisterVM extends BaseViewModel {
  final PageController pageController = PageController();
  int selectedPage = 0;
  bool termsAgree = false;
  bool isLoading = false;
  City? selectedCity;
  Area? selectedArea;
  AreaCubit areaCubit = AreaCubit();

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  bool newpasswordVisible = false;
  bool repeatnewpasswordVisible = false;

  onTermsAgreeChanged() {
    termsAgree = !termsAgree;
    notifyListeners();
  }

  onCitySelected(BuildContext context, City data) {
    selectedCity = data;
    selectedArea = null;
    areaCubit.fetchArea(context, idCity: data.id.toString());
    notifyListeners();
  }

  onAreaSelected(BuildContext context, Area data) {
    selectedArea = data;

    notifyListeners();
  }

  onNewPasswordVisibileChanged() {
    newpasswordVisible = !newpasswordVisible;
    notifyListeners();
  }

  onConfirmPasswordVisibleChanged() {
    repeatnewpasswordVisible = !repeatnewpasswordVisible;
    notifyListeners();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatNewPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  setSelectedPage(int value) {
    selectedPage = value;
    notifyListeners();
  }

  onNext() {
    pageController.animateToPage(selectedPage + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    selectedPage = selectedPage + 1;
    notifyListeners();
  }

  Future<bool> onBackPressed() {
    if (selectedPage == 0) {
      return Future.value(true);
    } else {
      pageController.animateToPage(selectedPage - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      selectedPage = selectedPage - 1;
      notifyListeners();
      return Future.value(false);
    }
  }

  onStep2Tap(BuildContext context) {
    if (newPasswordController.text != repeatNewPasswordController.text) {
      FormHelper.showSnackbar(context,
          data: 'Password Tidak Cocok', colors: Colors.orange);
    } else if (newPasswordController.text.length < 6) {
      FormHelper.showSnackbar(context,
          data: 'Password Minimal 6 karakter', colors: Colors.orange);
    } else if (formKey2.currentState!.validate()) {
      onNext();
    }
  }

  onStep3Tap(BuildContext context) {
    if (termsAgree == false) {
      FormHelper.showSnackbar(context,
          colors: Colors.orange,
          data: 'Mohon menyetujui ketentuan dan kondisi yang berlaku');
    } else {
      if (isLoading == false) {
        if (selectedCity == null || selectedArea == null) {
          FormHelper.showSnackbar(context,
              colors: Colors.orange, data: 'Mohon memilih kota dan area');

          return;
        }

        isLoading = true;
        notifyListeners();
        AuthService.register(context,
                name: fullNameController.text,
                email: emailController.text,
                username: userNameController.text,
                phone: phoneController.text,
                password: newPasswordController.text,
                cityId: selectedCity!.id.toString(),
                areaId: selectedArea!.id.toString())
            .then((value) {
          isLoading = false;
          notifyListeners();
          if (value.status == RequestStatus.successRequest) {
            FormHelper.showSnackbar(context,
                data: 'Berhasil melakukan registrasi', colors: Colors.green);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EmailVerifyPage(
                          data: value.data,
                          password: newPasswordController.text,
                        )));
          } else {
            FormHelper.showSnackbar(context,
                data: value.data ?? 'Gagal melakukan registrasi',
                colors: Colors.orange);
          }
        });
      }
    }
  }
}
