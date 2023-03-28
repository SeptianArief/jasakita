import 'package:equatable/equatable.dart';
import 'package:qixer/app/auth/model/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailed extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel data;

  const ProfileLoaded(this.data);

  @override
  List<Object> get props => [data];
}
