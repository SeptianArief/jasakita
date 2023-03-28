import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/slider_cubit/slider_state.dart';
import 'package:qixer/app/home/services/slider_service.dart';
import 'package:qixer/shared/models/api_return_helper.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  void fetchSlider(BuildContext context) {
    emit(SliderLoading());
    SliderService.fetchSlider(context).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(SliderLoaded(value.data));
      } else {
        emit(SliderFailed());
      }
    });
  }
}
