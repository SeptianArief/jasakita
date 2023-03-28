import 'package:flutter/material.dart';
import 'package:qixer/app/auth/pages/login_page.dart';
import 'package:qixer/app/splash/vm/intro_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return ViewModelBuilder<IntroVM>.reactive(
        viewModelBuilder: () {
          return IntroVM();
        },
        onViewModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Slider =============>
                    SizedBox(
                      height: screenHeight < fourinchScreenHeight
                          ? screenHeight - 490
                          : screenHeight - 550,
                    ),
                    SizedBox(
                      height: screenHeight < fourinchScreenHeight ? 290 : 370,
                      child: PageView.builder(
                          controller: model.pageController,
                          onPageChanged: (value) {
                            model.onChangePage(value);
                          },
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: screenHeight < fourinchScreenHeight
                                        ? 130
                                        : 260,
                                    margin: const EdgeInsets.only(bottom: 24),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(model.getImage(i)),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    model.geTitle(i),
                                    style: mainFont.copyWith(
                                        color: model.cc.greyPrimary,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),

                                  // Subtitle =============>
                                  CommonHelper().paragraphCommon(
                                      model.geSubTitle(i), TextAlign.center)
                                ],
                              ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //slider count show =======>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 3; i++)
                          Container(
                            margin: const EdgeInsets.only(right: 5),
                            height: 16,
                            width: 16,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: model.selectedSlide == i
                                        ? model.cc.primaryColor
                                        : Colors.transparent),
                                shape: BoxShape.circle),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: model.selectedSlide == i
                                      ? model.cc.primaryColor
                                      : const Color(0xffD0D5DD),
                                  shape: BoxShape.circle),
                            ),
                          )
                      ],
                    ),

//buttons
                    const SizedBox(
                      height: 42,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('intro', true);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (Route<dynamic> route) => false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: model.cc.primaryColor, width: 1.5),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Text(
                                model.selectedSlide == 2 ? 'Mulai' : 'Lewati',
                                style: mainFont.copyWith(
                                    color: model.cc.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: model.selectedSlide == 2 ? 0 : 18,
                        ),
                        model.selectedSlide == 2
                            ? Container()
                            : Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    model.onNext(context);
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      decoration: BoxDecoration(
                                          color: model.cc.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        'Selanjutnya',
                                        style: mainFont.copyWith(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ),
                              ),
                      ],
                    )
                  ]),
            ),
          );
        });
  }
}
