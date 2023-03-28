import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/app/home/widgets/categories_section.dart';
import 'package:qixer/app/home/widgets/profile_section.dart';
import 'package:qixer/app/home/widgets/service_by_city_section.dart';
import 'package:qixer/app/home/widgets/slider_section.dart';
import 'package:qixer/app/home/widgets/vendor_section.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/section_title.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<HomeVM>.reactive(viewModelBuilder: () {
      return HomeVM();
    }, onViewModelReady: (model) {
      model.onInit(context);
    }, builder: (context, model, child) {
      return Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            color: cc.primaryColor,
            onRefresh: () async {
              model.onInit(context);
            },
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: cc.primaryColor,
                      child: SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            //name and profile image
                            ProfileSection(model: model),

                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SliderSection(model: model),
                    CategoriesSection(model: model),
                    ServiceByCitySection(model: model),
                    VendorSection(model: model),
                    SizedBox(
                      height: 30,
                    )
                  ]),
            ),
          ),
        ),
      );
    });
  }
}
