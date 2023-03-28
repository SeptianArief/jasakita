import 'package:flutter/material.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:stacked/stacked.dart';

class NewServiceVM extends BaseViewModel {
  ServiceCubit serviceCubit = ServiceCubit();
  CategoriesCubit categoriesCubit = CategoriesCubit();

  onInit(BuildContext context) {
    serviceCubit.fetchNewestService(context);
    categoriesCubit.fetchCategories(context);
  }
}
