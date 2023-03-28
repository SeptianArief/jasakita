import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_state.dart';
import 'package:qixer/app/home/services/categories_service.dart';

import 'package:qixer/shared/models/api_return_helper.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  void fetchCategories(BuildContext context) {
    emit(CategoriesLoading());
    CategoriesService.fetchCategories(context).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(CategoriesLoaded(value.data));
      } else {
        emit(CategoriesFailed());
      }
    });
  }
}
