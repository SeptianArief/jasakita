import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/vm/register_vm.dart';
import 'package:qixer/app/auth/widgets/register_email_name.dart';
import 'package:qixer/app/auth/widgets/register_phone_widget.dart';
import 'package:qixer/app/auth/widgets/register_states_widget.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:stacked/stacked.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RegisterVM>.reactive(
        viewModelBuilder: () {
          return RegisterVM();
        },
        onViewModelReady: (model) {},
        builder: (context, model, child) {
          return Listener(
            onPointerDown: (_) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                return model.onBackPressed();
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: CommonHelper().appbarCommon('', context, () {
                  model.onBackPressed();
                }),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: CommonHelper()
                            .titleCommon("Daftar untuk bergabung"),
                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      //Page steps show =======>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < 3; i++)
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: model.selectedPage >= i
                                          ? cc.primaryColor
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: model.selectedPage >= i
                                              ? Colors.transparent
                                              : cc.greyFive)),
                                  child: model.selectedPage - 1 < i
                                      ? Text(
                                          '${i + 1}',
                                          style: mainFont.copyWith(
                                              color: model.selectedPage >= i
                                                  ? Colors.white
                                                  : cc.greyPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Icon(
                                          Icons.check_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                ),
                                //line
                                i > 1
                                    ? Container()
                                    : Container(
                                        height: 3,
                                        width: screenWidth / 2 - 85,
                                        color: model.selectedPage >= i
                                            ? cc.primaryColor
                                            : cc.greyFive,
                                      )
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(
                        height: 35,
                      ),

                      //Slider =============>
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            height: 750,
                            child: PageView.builder(
                                controller: model.pageController,
                                onPageChanged: (value) {
                                  model.setSelectedPage(value);
                                },
                                itemCount: 3,
                                itemBuilder: (context, i) {
                                  if (i == 0) {
                                    return SignupEmailName(
                                      model: model,
                                    );
                                  } else if (i == 1) {
                                    return SignupPhonePass(
                                      model: model,
                                    );
                                  } else {
                                    return RegisterStatesWidget(
                                      model: model,
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        });
  }
}
