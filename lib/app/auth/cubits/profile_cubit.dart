import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/shared/models/api_return_helper.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void fetchProfile(BuildContext context,
      {required String token, bool refresh = false}) {
    if (refresh) {
      emit(ProfileLoading());
    }
    AuthService.profile(context, token: token).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ProfileLoaded(value.data));
      } else {
        emit(ProfileFailed());
      }
    });
  }
}
