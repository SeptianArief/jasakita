import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/app/auth/vm/forgot_password_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/languages/app_string_service.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<ForgotPasswordVM>.reactive(
        viewModelBuilder: () {
          return ForgotPasswordVM();
        },
        onViewModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
            appBar:
                CommonHelper().appbarCommon('Reset Kata Sandi', context, () {
              Navigator.pop(context);
            }),
            backgroundColor: Colors.white,
            body: Listener(
              onPointerDown: (_) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: MediaQuery.of(context).size.height - 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: model.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 33,
                            ),
                            Text(
                              "Reset kata sandi",
                              style: mainFont.copyWith(
                                  color: cc.greyPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            CommonHelper().paragraphCommon(
                                "Masukkan Nomor Handphone dan Password Baru akan dikirimkan melalui Whatsapp Anda",
                                TextAlign.start),

                            const SizedBox(
                              height: 33,
                            ),

                            //Name ============>
                            CommonHelper().labelCommon(
                              "Masukkan Nomor Handphone",
                            ),

                            CustomInput(
                              controller: model.emailController,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukkan Nomor Handphone Anda";
                                }
                                return null;
                              },
                              hintText: "Nomor handphone",
                              textInputAction: TextInputAction.next,
                            ),

                            //Login button ==================>
                            const SizedBox(
                              height: 13,
                            ),
                            CommonHelper().buttonOrange("Kirim", () {
                              if (model.formKey.currentState!.validate()) {
                                model.onSubmitForgotPassword(context);
                              }
                            }, isloading: model.isLoading),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
