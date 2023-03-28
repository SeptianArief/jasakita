import 'package:flutter/material.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:stacked/stacked.dart';

import '../../../shared/form_helper.dart';

class ForgotPasswordVM extends BaseViewModel {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  onSubmitForgotPassword(
    BuildContext context,
  ) {
    isLoading = true;
    notifyListeners();
    AuthService.forgotPassword(context, phone: emailController.text)
        .then((value) {
      isLoading = false;
      notifyListeners();
      if (value.status == RequestStatus.successRequest) {
        FormHelper.showSnackbar(context,
            data:
                'Berhasil reset password, silahkan login kembali menggunakan password yang telah kami kirim melalui WhatsApp',
            colors: Colors.green);
        Navigator.pop(context);
      } else {
        FormHelper.showSnackbar(context,
            data: value.data ?? 'Gagal Melakukan Reset Password',
            colors: Colors.orange);
      }
    });
  }
}
