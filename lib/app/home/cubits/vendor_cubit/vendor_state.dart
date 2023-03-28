import 'package:equatable/equatable.dart';
import 'package:qixer/app/home/models/vendor_model.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object> get props => [];
}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

class VendorFailed extends VendorState {}

class VendorLoaded extends VendorState {
  final List<VendorModelPreview> data;

  const VendorLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class VendorDetailLoaded extends VendorState {
  final VendorDetail data;

  const VendorDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}
