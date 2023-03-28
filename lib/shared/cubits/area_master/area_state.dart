import 'package:equatable/equatable.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';

abstract class AreaState extends Equatable {
  const AreaState();

  @override
  List<Object> get props => [];
}

class AreaInitial extends AreaState {}

class AreaLoading extends AreaState {}

class AreaFailed extends AreaState {}

class AreaLoaded extends AreaState {
  final List<Area> data;

  const AreaLoaded(this.data);

  @override
  List<Object> get props => [data];
}
