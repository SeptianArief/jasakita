import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/model/report_list_model.dart';
import 'package:qixer/app/order/model/ticket_list_model.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/shared/form_helper.dart';

import 'package:qixer/shared/models/api_return_helper.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  void fetchDetailOrder(BuildContext context, {required String id}) {
    emit(OrderLoading());
    OrderService.fetchDetailOrder(context, orderId: id).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(OrderDetailLoaded(value.data));
      } else {
        emit(OrderFailed());
      }
    });
  }

  void fetchOrder(BuildContext context) {
    emit(OrderLoading());
    OrderService.fetchOrderList(context).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(OrderLoaded(value.data));
      } else {
        emit(OrderFailed());
      }
    });
  }

  void fetchReportList(BuildContext context, {ReportListLoaded? currState}) {
    if (currState == null) {
      emit(OrderLoading());
      OrderService.reportList(context).then((value) {
        if (value.status == RequestStatus.successRequest) {
          emit(ReportListLoaded(value.data));
        } else {
          emit(OrderFailed());
        }
      });
    } else {
      if (currState.data.currentPage < currState.data.lastPage) {
        OrderService.reportList(context,
                page: (currState.data.currentPage).toString())
            .then((value) {
          if (value.status == RequestStatus.successRequest) {
            List<ReportListModel> dataFinal = currState.data.data;

            ReportListModelMaster dataDB = value.data;

            dataFinal.addAll(dataDB.data);

            dataDB.data = dataFinal;
            emit(OrderLoading());
            emit(ReportListLoaded(dataDB));
          } else {
            FormHelper.showSnackbar(context,
                data: 'Gagal mengambil data', colors: Colors.orange);
          }
        });
      }
    }
  }

  void fetchTicketList(BuildContext context, {TicketListLoaded? currentState}) {
    if (currentState == null) {
      emit(OrderLoading());
      OrderService.ticketList(context).then((value) {
        if (value.status == RequestStatus.successRequest) {
          emit(TicketListLoaded(value.data));
        } else {
          emit(OrderFailed());
        }
      });
    } else {
      if (currentState.data.currentPage < currentState.data.lastPage) {
        OrderService.ticketList(context,
                page: (currentState.data.currentPage).toString())
            .then((value) {
          if (value.status == RequestStatus.successRequest) {
            List<TicketModel> dataFinal = currentState.data.data;

            TicketMasterModel dataDB = value.data;

            dataFinal.addAll(dataDB.data);

            dataDB.data = dataFinal;
            emit(OrderLoading());
            emit(TicketListLoaded(dataDB));
          } else {
            FormHelper.showSnackbar(context,
                data: 'Gagal mengambil data', colors: Colors.orange);
          }
        });
      }
    }
  }

  void fetchSchedule(BuildContext context,
      {required String day,
      required String sellerId,
      required Function(List<dynamic>) onSucess}) {
    emit(OrderLoading());
    OrderService.fetchSchedule(context, selectedWeek: day, sellerId: sellerId)
        .then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(ScheduleLoaded(value.data));
        onSucess(value.data);
      } else {
        emit(OrderFailed());
      }
    });
  }

  fetchDeclineHistory(BuildContext context, {required String orderId}) {
    emit(OrderLoading());
    OrderService.fetchDeclineHistory(context, orderId: orderId).then((value) {
      if (value.status == RequestStatus.successRequest) {
        emit(OrderDeclineLoaded(value.data));
      } else {
        emit(OrderFailed());
      }
    });
  }
}
