import 'package:equatable/equatable.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityFailed extends CityState {}

class CityLoaded extends CityState {
  final List<City> data;

  const CityLoaded(this.data);

  @override
  List<Object> get props => [data];
}
