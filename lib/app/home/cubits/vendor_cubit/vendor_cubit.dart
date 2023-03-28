import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_state.dart';
import 'package:qixer/app/home/models/vendor_model.dart';
import 'package:qixer/app/home/services/vendor_service.dart';

import 'package:qixer/shared/models/api_return_helper.dart';

class VendorCubit extends Cubit<VendorState> {
  VendorCubit() : super(VendorInitial());

  void fetchVendor(BuildContext context) {
    emit(VendorLoading());
    VendorService.fetchVendorHome(context).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(VendorLoaded(value.data));
      } else {
        emit(VendorFailed());
      }
    });
  }

  void fetchVendorDetail(BuildContext context, {required String id}) {
    emit(VendorLoading());
    VendorService.fetchVendorDetail(context, id: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(VendorDetailLoaded(value.data));
      } else {
        emit(VendorFailed());
      }
    });
  }
}
