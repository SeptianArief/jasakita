import 'package:equatable/equatable.dart';
import 'package:qixer/app/home/models/service_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceFailed extends ServiceState {}

class ServiceGroupingLoaded extends ServiceState {
  final List<ServiceGrouping> data;

  const ServiceGroupingLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceLoaded extends ServiceState {
  final List<ServiceModel> data;

  const ServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceDetailLoaded extends ServiceState {
  final ServiceDetail data;

  const ServiceDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ServiceBookingLoaded extends ServiceState {
  final ServiceBookingModel data;

  const ServiceBookingLoaded(this.data);

  @override
  List<Object> get props => [data];
}
