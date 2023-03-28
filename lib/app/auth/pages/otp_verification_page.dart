import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/model/user_model.dart';
import 'package:qixer/app/auth/vm/otp_verif_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class EmailVerifyPage extends StatefulWidget {
  final User data;
  final String password;
  const EmailVerifyPage({
    Key? key,
    required this.data,
    required this.password,
  }) : super(key: key);

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  StreamController<ErrorAnimationType>? errorController;

  String currentText = "";
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<OtpVerifVM>.reactive(viewModelBuilder: () {
      return OtpVerifVM();
    }, onViewModelReady: (model) {
      model.onInit(context,
          dataParam: widget.data, passwordParam: widget.password);
    }, builder: (context, model, child) {
      return Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Scaffold(
          appBar: CommonHelper().appbarCommon('Verifikasi', context, () {
            Navigator.pop(context);
          }),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                ),
                CommonHelper().titleCommon("Masukkan Kode OTP"),
                const SizedBox(
                  height: 13,
                ),
                CommonHelper().paragraphCommon(
                    'Masukan kode OTP 4 digit yang telah dikirimkan ke nomor Whatsapp Anda.',
                    TextAlign.center),
                const SizedBox(
                  height: 33,
                ),
                Form(
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    showCursor: true,
                    cursorColor: cc.greyFive,

                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 70,
                        activeFillColor: Colors.white,
                        borderWidth: 1.5,
                        selectedColor: cc.primaryColor,
                        activeColor: cc.primaryColor,
                        inactiveColor: cc.greyFive),
                    animationDuration: const Duration(milliseconds: 200),
                    // backgroundColor: Colors.white,
                    // enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: model.textEditingController,
                    onCompleted: (otp) {
                      model.onSendOTP(context, otpInput: otp);
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),

                //Loading bar
                model.verifyOtpLoading == true
                    ? Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 5),
                        alignment: Alignment.center,
                        child: showLoading(cc.primaryColor),
                      )
                    : Container(),

                const SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !model.isloading
                        ? RichText(
                            text: TextSpan(
                              text: 'Tidak Menerima? ',
                              style: mainFont.copyWith(
                                  color: Color(0xff646464), fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        model.sendOtp(context);
                                      },
                                    text: 'Kirim Ulang',
                                    style: mainFont.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: cc.primaryColor,
                                    )),
                              ],
                            ),
                          )
                        : showLoading(cc.primaryColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
