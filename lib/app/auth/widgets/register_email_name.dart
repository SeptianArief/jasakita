import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/app/auth/vm/register_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';

class SignupEmailName extends StatelessWidget {
  final RegisterVM model;
  const SignupEmailName({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: model.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHelper().labelCommon("Nama Lengkap"),

              CustomInput(
                controller: model.fullNameController,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon Masukan Nama Lengkap Anda';
                  }
                  return null;
                },
                hintText: "Masukan Nama Lengkap Anda",
                icon: 'assets/icons/user.png',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 18,
              ),

              //User name ============>
              CommonHelper().labelCommon("Username"),

              CustomInput(
                controller: model.userNameController,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukan username Anda';
                  }
                  return null;
                },
                hintText: "Masukan username Anda",
                icon: 'assets/icons/user.png',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 18,
              ),

              //Email ============>
              CommonHelper().labelCommon("Email"),

              CustomInput(
                controller: model.emailController,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukan email Anda';
                  }
                  return null;
                },
                hintText: "Masukan email Anda",
                icon: 'assets/icons/email-grey.png',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 18,
              ),

              //Login button ==================>
              const SizedBox(
                height: 13,
              ),
              CommonHelper().buttonOrange(("Lanjutkan"), () {
                if (model.formKey.currentState!.validate()) {
                  model.onNext();
                }
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
                                        builder: (context) =>
                                            const LoginPage()));
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
              )

              //Divider (or)
              //             const SizedBox(
              //               height: 30,
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Expanded(
              //                     child: Container(
              //                   height: 1,
              //                   color: cc.greyFive,
              //                 )),
              //                 Container(
              //                   width: 40,
              //                   alignment: Alignment.center,
              //                   margin: const EdgeInsets.only(bottom: 25),
              //                   child: Text(
              //                     "OR",
              //                     style: mainFont.copyWith(
              //                         color: cc.greyPrimary,
              //                         fontSize: 17,
              //                         fontWeight: FontWeight.w600),
              //                   ),
              //                 ),
              //                 Expanded(
              //                     child: Container(
              //                   height: 1,
              //                   color: cc.greyFive,
              //                 )),
              //               ],
              //             ),

              // //login with google, facebook button ===========>
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             InkWell(
              //                 onTap: () {},
              //                 child: LoginHelper().commonButton(
              //                     'assets/icons/google.png', "Login with Google")),
              //             const SizedBox(
              //               height: 20,
              //             ),
              //             InkWell(
              //                 onTap: () {},
              //                 child: LoginHelper().commonButton(
              //                     'assets/icons/facebook.png', "Login with Facebook")),

              //             const SizedBox(
              //               height: 30,
              //             ),
            ],
          ),
        ));
  }
}
