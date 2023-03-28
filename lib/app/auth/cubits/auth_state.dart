import 'package:equatable/equatable.dart';
import 'package:qixer/app/auth/model/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLogged extends UserState {
  final User user;

  const UserLogged(this.user);

  @override
  List<Object> get props => [user];
}
