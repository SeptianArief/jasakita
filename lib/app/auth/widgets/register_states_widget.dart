import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/app/auth/vm/register_vm.dart';
import 'package:qixer/app/auth/widgets/area_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class RegisterStatesWidget extends StatelessWidget {
  final RegisterVM model;
  const RegisterStatesWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Kota',
              style: mainFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(
              height: 10,
            ),
            DropdownCityAll(
              onChanged: (value) {
                model.onCitySelected(context, value);
              },
              selectedCity: model.selectedCity?.id,
              showAll: false,
            ),
            SizedBox(
              height: 20,
            ),

            model.selectedCity == null
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Area',
                        style: mainFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AreaDropdown(
                        cubit: model.areaCubit,
                        showAll: false,
                        onChanged: (value) {
                          model.onAreaSelected(context, value);
                        },
                        selectedCity: model.selectedArea?.id,
                      )
                    ],
                  ),

            //Agreement checkbox ===========>
            const SizedBox(
              height: 17,
            ),
            CheckboxListTile(
              checkColor: Colors.white,
              activeColor: ConstantColors().primaryColor,
              contentPadding: const EdgeInsets.all(0),
              title: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Saya setuju dengan ketentuan dan kondisi yang berlaku",
                  style: mainFont.copyWith(
                      color: ConstantColors().greyFour,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              value: model.termsAgree,
              onChanged: (newValue) {
                model.onTermsAgreeChanged();
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            //Login button ==================>
            const SizedBox(
              height: 17,
            ),
            CommonHelper().buttonOrange("Daftar", () {
              model.onStep3Tap(context);
            }, isloading: model.isLoading),

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
        ));
  }
}
