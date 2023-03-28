import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/app/auth/vm/register_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';

class SignupPhonePass extends StatelessWidget {
  final RegisterVM model;
  const SignupPhonePass({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: model.formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Phone number field
            CommonHelper().labelCommon("Nomor Handphone"),
            CustomInput(
              controller: model.phoneController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon masukan nomor handphone Anda';
                }
                return null;
              },
              hintText: "Nomor Handphone",
              isNumberField: true,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: 20),

            //New password =========================>
            CommonHelper().labelCommon("Kata Sandi"),

            Container(
                margin: const EdgeInsets.only(bottom: 19),
                decoration: BoxDecoration(
                    // color: const Color(0xfff2f2f2),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: model.newPasswordController,
                  textInputAction: TextInputAction.next,
                  obscureText: !model.newpasswordVisible,
                  style: mainFont.copyWith(fontSize: 14),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mohon masukan kata sandi Anda";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 22.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/lock.png'),
                                  fit: BoxFit.fitHeight),
                            ),
                          ),
                        ],
                      ),
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          model.newpasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {
                          model.onNewPasswordVisibileChanged();
                          // Update the state i.e. toogle the state of passwordVisible variable
                          // setState(() {
                          //   model.newpasswordVisible = !model.newpasswordVisible;
                          // });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().greyFive),
                          borderRadius: BorderRadius.circular(9)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().primaryColor)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().warningColor)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().primaryColor)),
                      hintText: "Masukkan kata sandi",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 18)),
                )),

            //Repeat New password =========================>
            CommonHelper().labelCommon("Ulangi kata sandi"),

            Container(
                margin: const EdgeInsets.only(bottom: 19),
                decoration: BoxDecoration(
                    // color: const Color(0xfff2f2f2),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: model.repeatNewPasswordController,
                  textInputAction: TextInputAction.next,
                  obscureText: !model.repeatnewpasswordVisible,
                  style: mainFont.copyWith(fontSize: 14),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mohon masukkan konfirmasi kata sandi Anda";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 22.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/lock.png'),
                                  fit: BoxFit.fitHeight),
                            ),
                          ),
                        ],
                      ),
                      suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          model.repeatnewpasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          model.onConfirmPasswordVisibleChanged();
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().greyFive),
                          borderRadius: BorderRadius.circular(9)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().primaryColor)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().warningColor)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ConstantColors().primaryColor)),
                      hintText: "Masukkan kata sandi",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 18)),
                )),

            //Login button ==================>
            const SizedBox(
              height: 13,
            ),

            CommonHelper().buttonOrange("Lanjutkan", () {
              model.onStep2Tap(context);
            }),

            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Punya akun?  ',
                    style: mainFont.copyWith(
                        color: Color(0xff646464), fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                          text: 'Masuk',
                          style: mainFont.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: cc.primaryColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
