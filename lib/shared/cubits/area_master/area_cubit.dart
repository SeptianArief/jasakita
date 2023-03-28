import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/shared/cubits/area_master/area_service.dart';
import 'package:qixer/shared/cubits/area_master/area_state.dart';
import 'package:qixer/shared/models/api_return_helper.dart';

class AreaCubit extends Cubit<AreaState> {
  AreaCubit() : super(AreaInitial());

  void fetchArea(BuildContext context, {required String idCity}) {
    emit(AreaLoading());
    AreaService.fetchArea(context, idCity: idCity).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(AreaLoaded(value.data));
      } else {
        emit(AreaFailed());
      }
    });
  }
}
