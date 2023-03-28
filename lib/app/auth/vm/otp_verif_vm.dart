import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/model/user_model.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:stacked/stacked.dart';

class OtpVerifVM extends BaseViewModel {
  String token = '';
  String phone = '';
  TextEditingController textEditingController = TextEditingController();
  bool verifyOtpLoading = false;
  bool isloading = false;
  String otp = '';
  late User data;
  late String password;

  sendOtp(BuildContext context) {
    isloading = true;
    notifyListeners();
    AuthService.sendOTPPhone(context, phone: phone, token: token).then((value) {
      if (value.status == RequestStatus.successRequest) {
        isloading = false;
        notifyListeners();
        otp = value.data.toString();
        print('otp' + ' ' + otp);
        notifyListeners();
        FormHelper.showSnackbar(context,
            data: 'Berhasil mengirim OTP', colors: Colors.green);
      } else {
        isloading = false;
        notifyListeners();
        FormHelper.showSnackbar(context,
            data: value.data ?? 'Gagal mengirim OTP', colors: Colors.orange);
      }
    });
  }

  onInit(
    BuildContext context, {
    required String passwordParam,
    required User dataParam,
  }) {
    password = passwordParam;
    token = dataParam.token;
    data = dataParam;
    phone = dataParam.phone;
    sendOtp(context);
  }

  onSendOTP(BuildContext context, {required String otpInput}) {
    if (otp == otpInput) {
      verifyOtpLoading = true;
      notifyListeners();
      AuthService.verifOTP(
        context,
        data: data,
      ).then((value) {
        verifyOtpLoading = false;
        notifyListeners();
        if (value.status == RequestStatus.successRequest) {
          BlocProvider.of<UserCubit>(context)
              .loginOnRegister(context, data: data, password: password);
        } else {
          FormHelper.showSnackbar(context,
              data: 'Gagal memverifikasi, mohon coba lagi',
              colors: Colors.orange);
        }
      });
    } else {
      FormHelper.showSnackbar(context,
          data: 'OTP salah', colors: Colors.orange);
    }
  }
}
