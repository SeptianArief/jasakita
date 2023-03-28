import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/services/service_service.dart';

import 'package:qixer/shared/models/api_return_helper.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitial());

  void fetchServiceGrouping(BuildContext context, {required String city}) {
    emit(ServiceLoading());
    ServiceService.fetchByCity(context, city: city).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceGroupingLoaded(value.data));
      } else {
        emit(ServiceFailed());
      }
    });
  }

  void fetchServiceByCategories(BuildContext context,
      {required String idCategory, String? stateId}) {
    emit(ServiceLoading());
    ServiceService.fetchByCategory(context,
            idCategory: idCategory, stateId: stateId)
        .then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceLoaded(value.data));
      } else {
        emit(ServiceFailed());
      }
    });
  }

  void fetchNewestService(BuildContext context) {
    emit(ServiceLoading());
    ServiceService.fetchNew(
      context,
    ).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceLoaded(value.data));
      } else {
        emit(ServiceFailed());
      }
    });
  }

  void searchService(BuildContext context,
      {required String cityId, String search = ''}) {
    emit(ServiceLoading());
    ServiceService.fetchSearch(context, city: cityId, search: search)
        .then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceLoaded(value.data));
      } else {
        emit(ServiceFailed());
      }
    });
  }

  fetchDetail(BuildContext context, {required String id}) {
    emit(ServiceLoading());
    ServiceService.fetchDetailService(context, id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceDetailLoaded(value.data));
      } else {
        emit(ServiceFailed());
      }
    });
  }

  fetchDetailBookingService(BuildContext context, {required String id}) {
    emit(ServiceLoading());
    ServiceService.fetchDetailServiceBooking(context, id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ServiceBookingLoaded(value.data));
      } else {
        emit(ServiceFailed());
      }
    });
  }

  updateBookingState(ServiceBookingModel data) {
    emit(ServiceLoading());
    emit(ServiceBookingLoaded(data));
  }
}
