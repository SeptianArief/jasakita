import 'package:equatable/equatable.dart';
import 'package:qixer/app/home/models/slider_model.dart';

abstract class SliderState extends Equatable {
  const SliderState();

  @override
  List<Object> get props => [];
}

class SliderInitial extends SliderState {}

class SliderLoading extends SliderState {}

class SliderFailed extends SliderState {}

class SliderLoaded extends SliderState {
  final List<SliderModel> data;

  const SliderLoaded(this.data);

  @override
  List<Object> get props => [data];
}
