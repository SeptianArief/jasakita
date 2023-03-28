import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/widgets/amount_details.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/app/order/widgets/complete_request_widget.dart';
import 'package:qixer/app/order/widgets/decline_history.dart';
import 'package:qixer/app/order/widgets/order_extras_widget.dart';
import 'package:qixer/app/order/widgets/seller_detail_order.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';

getOrderStatus(int status) {
  if (status == 0) {
    return 'Pending';
  } else if (status == 1) {
    return 'Aktif';
  } else if (status == 2) {
    return "Selesai";
  } else if (status == 3) {
    return "Proses";
  } else if (status == 4) {
    return 'Batal';
  } else {
    return 'Unknown';
  }
}

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage(
      {Key? key, required this.orderId, required this.orderType})
      : super(key: key);

  final orderId;
  final String orderType;

  @override
  _OrdersDetailsPageState createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrderDetailsPage> {
  OrderCubit orderCubit = OrderCubit();
  OrderCubit declineCubit = OrderCubit();

  @override
  void initState() {
    orderCubit.fetchDetailOrder(context, id: widget.orderId);
    super.initState();
  }

  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cc.bgColor,
      appBar: CommonHelper().appbarCommon('Detil Pesanan', context, () {
        Navigator.pop(context);
      }),
      body: BlocBuilder<OrderCubit, OrderState>(
          bloc: orderCubit,
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(
                child: showLoading(cc.primaryColor),
              );
            } else if (state is OrderDetailLoaded) {
              return SafeArea(
                child: SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonHelper().titleCommon('Detil Vendor'),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  //Service row

                                  Container(
                                    child: BookingHelper()
                                        .bRow('null', 'Jasa', widget.orderType),
                                  ),
                                  Container(
                                    child: BookingHelper().bRow(
                                        'null',
                                        'Catatan',
                                        state.data.data.orderNote ?? '-'),
                                  ),
                                  Container(
                                    child: BookingHelper().bRow('null', 'Brand',
                                        state.data.data.brands ?? '-',
                                        lastBorder: false),
                                  ),
                                ])),

                        SizedBox(
                          height: 10,
                        ),

                        //Seller details
                        SellerDetails(
                          data: state.data,
                        ),
                        // Date and schedule
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper()
                                    .titleCommon('Tanggal dan Jadwal'),
                                const SizedBox(
                                  height: 25,
                                ),
                                //Service row

                                Container(
                                  child: BookingHelper().bRow(
                                      'null', 'Tanggal', state.data.data.date),
                                ),

                                Container(
                                  child: BookingHelper().bRow('null',
                                      'Schedule', state.data.data.scheulde,
                                      lastBorder: false),
                                ),
                              ]),
                        ),

                        //amount details
                        AmountDetails(
                          data: state.data,
                          url: state.data.paymentUrl,
                        ),

                        // Date and schedule
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper().titleCommon('Status Pesanan'),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  child: BookingHelper().bRow(
                                      'null',
                                      'Status Pesanan',
                                      getOrderStatus(state.data.data.status),
                                      lastBorder: false),
                                ),
                              ]),
                        ),

                        DeclineHistory(
                          id: widget.orderId,
                          orderCubit: declineCubit,
                        ),

                        // order extras
                        // ==============>
                        // OrderExtras(
                        //   orderId: widget.orderId,
                        //   sellerId: state.data.data.sellerId,
                        // ),

                        //complete request
                        CompleteRequest(
                          orderId: widget.orderId,
                          data: state.data,
                          refreshDecline: () {
                            declineCubit.fetchDeclineHistory(context,
                                orderId: widget.orderId);
                          },
                        ),
                      ]),
                )),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
