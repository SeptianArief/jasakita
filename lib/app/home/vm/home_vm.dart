import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/auth/model/user_model.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/slider_cubit/slider_cubit.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_cubit.dart';
import 'package:qixer/shared/cubits/city_master/city_cubit.dart';
import 'package:qixer/shared/cubits/city_master/city_state.dart';
import 'package:stacked/stacked.dart';

class HomeVM extends BaseViewModel {
  late User data;
  SliderCubit sliderCubit = SliderCubit();
  CategoriesCubit categoriesCubit = CategoriesCubit();
  CityCubit availableCityCubit = CityCubit();
  ServiceCubit serviceByCityCubit = ServiceCubit();
  VendorCubit vendorCubit = VendorCubit();

  String getLocationMaster(BuildContext context) {
    String returnValue = '';

    ProfileState state = BlocProvider.of<ProfileCubit>(context).state;
    if (state is ProfileLoaded) {
      returnValue = state.data.detail.city.serviceCity;
    }

    return returnValue;
  }

  onInit(BuildContext context) {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLogged) {
      data = userState.user;
      notifyListeners();
    }

    sliderCubit.fetchSlider(context);
    categoriesCubit.fetchCategories(context);
    availableCityCubit.availableCity(context);
    serviceByCityCubit.fetchServiceGrouping(context,
        city: getLocationMaster(context));
    vendorCubit.fetchVendor(context);
  }
}
