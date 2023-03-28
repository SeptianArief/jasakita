import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/shared/cubits/city_master/city_service.dart';
import 'package:qixer/shared/cubits/city_master/city_state.dart';
import 'package:qixer/shared/models/api_return_helper.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityInitial());

  void fetchCity(BuildContext context) {
    emit(CityLoading());
    CityService.fetchCity(context).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(CityLoaded(value.data));
      } else {
        emit(CityFailed());
      }
    });
  }

  void availableCity(BuildContext context) {
    emit(CityLoading());
    CityService.availableCity(context).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(CityLoaded(value.data));
      } else {
        emit(CityFailed());
      }
    });
  }
}
