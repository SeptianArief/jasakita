import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/pages/forgot_password_page.dart';
import 'package:qixer/app/auth/pages/register_page.dart';
import 'package:qixer/app/auth/vm/login_vm.dart';
import 'package:qixer/app/landing/pages/landing_page.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';
import 'package:qixer/shared/form_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.hasBackButton = true}) : super(key: key);

  final hasBackButton;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginVM>.reactive(
        viewModelBuilder: () {
          return LoginVM();
        },
        onViewModelReady: (model) {},
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              return model.onBackPressed(context);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Listener(
                onPointerDown: (_) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.focusedChild?.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Stack(
                      //   children: [
                      //     Container(
                      //       height: 230.0,
                      //       width: double.infinity,
                      //       decoration: const BoxDecoration(
                      //         image: DecorationImage(
                      //           image: AssetImage('assets/images/login-slider.png'),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(
                        height: 66,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          key: model.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(
                              //   height: 33,
                              // ),

                              // CommonHelper().titleCommon(
                              //     'Welcome back! Login')),

                              const SizedBox(
                                height: 33,
                              ),

                              //Name ============>
                              CommonHelper().labelCommon("Nomor Handphone"),

                              CustomInput(
                                controller: model.emailController,
                                isNumberField: true,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mohon Masukkan Nomor Handphone Anda';
                                  }
                                  return null;
                                },
                                hintText: 'Masukkan Nomor Handphone',
                                icon: 'assets/icons/user.png',
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(
                                height: 25,
                              ),

                              //password ===========>
                              CommonHelper().labelCommon("Kata Sandi"),

                              Container(
                                  margin: const EdgeInsets.only(bottom: 19),
                                  decoration: BoxDecoration(
                                      // color: const Color(0xfff2f2f2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: model.passwordController,
                                    textInputAction: TextInputAction.next,
                                    obscureText: !model.passwordVisible,
                                    style: mainFont.copyWith(fontSize: 14),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mohon Memasukkan Kata Sandi';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 22.0,
                                              width: 40.0,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/icons/lock.png'),
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
                                            model.passwordVisible
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.grey,
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            model.passwordVisibleChanged();
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ConstantColors().greyFive),
                                            borderRadius:
                                                BorderRadius.circular(9)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ConstantColors()
                                                    .primaryColor)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ConstantColors()
                                                    .warningColor)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ConstantColors()
                                                    .primaryColor)),
                                        hintText: 'Masukkan Kata Sandi',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 18)),
                                  )),

                              // =================>
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //keep logged in checkbox
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:
                                          ConstantColors().primaryColor,
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          "Ingat Saya",
                                          style: mainFont.copyWith(
                                              color: ConstantColors().greyFour,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ),
                                      value: model.keepLoggedIn,
                                      onChanged: (newValue) {
                                        model.keepLoggedinChanged();
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const ForgotPasswordPage(),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 122,
                                      child: Text(
                                        "Lupa Kata Sandi?",
                                        style: mainFont.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              //Login button ==================>
                              const SizedBox(
                                height: 13,
                              ),

                              CommonHelper().buttonOrange("Login", () {
                                model.onLogin(context);
                              }, isloading: model.isLoading),

                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Tidak punya akun?  ',
                                      style: mainFont.copyWith(
                                          color: Color(0xff646464),
                                          fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignupPage()));
                                              },
                                            text: 'Daftar',
                                            style: mainFont.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
