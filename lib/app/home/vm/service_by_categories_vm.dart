import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/shared/cubits/area_master/area_cubit.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:stacked/stacked.dart';

class ServiceByCategoriesVM extends BaseViewModel {
  ServiceCubit serviceCubit = ServiceCubit();
  City? selectedCity;
  Area? selectedArea;
  AreaCubit areaCubit = AreaCubit();

  onCityChanged(BuildContext context, City data, {required String id}) async {
    if (data.id == 99) {
      selectedCity = null;
    } else {
      selectedCity = data;
      selectedArea = null;
      areaCubit.fetchArea(context, idCity: data.id.toString());
    }

    serviceCubit.fetchServiceByCategories(context,
        idCategory: id,
        stateId: selectedCity == null ? null : selectedCity!.id.toString());
    notifyListeners();
  }

  onAreaCahanged(BuildContext context, {required Area data}) {
    if (data.id == 99) {
      selectedArea = null;
    } else {
      selectedArea = data;
    }
    notifyListeners();
  }

  onInit(BuildContext context, {required String id}) async {
    serviceCubit.fetchServiceByCategories(context, idCategory: id);
  }
}
