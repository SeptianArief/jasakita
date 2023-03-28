import 'package:equatable/equatable.dart';

import 'package:qixer/app/order/model/order_model.dart';
import 'package:qixer/app/order/model/report_list_model.dart';
import 'package:qixer/app/order/model/ticket_list_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderFailed extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderPreview> data;

  const OrderLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ScheduleLoaded extends OrderState {
  final List<dynamic> data;

  const ScheduleLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ReportListLoaded extends OrderState {
  final ReportListModelMaster data;

  const ReportListLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TicketListLoaded extends OrderState {
  final TicketMasterModel data;

  const TicketListLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class OrderDetailLoaded extends OrderState {
  final OrderDetailModel data;

  const OrderDetailLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class OrderDeclineLoaded extends OrderState {
  final dynamic data;

  const OrderDeclineLoaded(this.data);

  @override
  List<Object> get props => [data];
}
