import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/pages/order_detail_page.dart';
import 'package:qixer/app/order/widgets/order_helper.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/widget_helper.dart';

String orderStatusToIndo(String value) {
  if (value == 'Active') {
    return 'Aktif';
  } else if (value == 'Delivered') {
    return 'Proses';
  } else if (value == 'Complete') {
    return 'Selesai';
  } else {
    return value;
  }
}

class OrdersPage extends StatefulWidget {
  final OrderCubit orderCubit;
  const OrdersPage({Key? key, required this.orderCubit}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    getOrderStatus(status) {
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

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                CommonHelper().titleCommon('Pesanan Saya'),
                const SizedBox(
                  height: 10,
                ),

                BlocBuilder<OrderCubit, OrderState>(
                    bloc: widget.orderCubit,
                    builder: (context, state) {
                      if (state is OrderLoaded) {
                        return state.data.isEmpty
                            ? CommonHelper().nothingfound(
                                context, 'Tidak ada Data Pesanan',
                                customSize:
                                    MediaQuery.of(context).size.height - 150)
                            : Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    widget.orderCubit.fetchOrder(context);
                                  },
                                  child: ListView.builder(
                                      itemCount: state.data.length,
                                      itemBuilder: ((context, i) => InkWell(
                                            onTap: () async {
                                              bool? result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          OrderDetailsPage(
                                                              orderId: state
                                                                  .data[i].id
                                                                  .toString(),
                                                              orderType: state
                                                                  .data[i]
                                                                  .serviceName)));

                                              if (result != null) {
                                                // ignore: use_build_context_synchronously
                                                widget.orderCubit
                                                    .fetchOrder(context);
                                              }
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                                bottom: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: cc.borderColor),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 6, 0, 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'ID No. ${state.data[i].id}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            mainFont.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              cc.primaryColor,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          OrdersHelper()
                                                              .statusCapsule(
                                                                  getOrderStatus(
                                                                      state
                                                                          .data[
                                                                              i]
                                                                          .status),
                                                                  cc.greyFour),
                                                          PopupMenuButton(
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                              for (int j = 0;
                                                                  j <
                                                                      OrdersHelper()
                                                                          .ordersPopupMenuList
                                                                          .length;
                                                                  j++)
                                                                PopupMenuItem(
                                                                  onTap:
                                                                      () async {
                                                                    Future.delayed(
                                                                        Duration
                                                                            .zero,
                                                                        () async {
                                                                      //

                                                                      if (j ==
                                                                              1 &&
                                                                          (state.data[i].paymentStatus == 'complete' ||
                                                                              state.data[i].status != 0)) {
                                                                        //0 means pending

                                                                        FormHelper.showSnackbar(
                                                                            context,
                                                                            data:
                                                                                'Anda tidak dapat membatalkan pesanan ini',
                                                                            colors:
                                                                                Colors.orange);

                                                                        return;
                                                                      }
                                                                      bool? result = await OrdersHelper().navigateMyOrders(
                                                                          context,
                                                                          index:
                                                                              j,
                                                                          serviceId: state
                                                                              .data[
                                                                                  i]
                                                                              .id,
                                                                          orderId: state
                                                                              .data[i]
                                                                              .id);
                                                                      if (result !=
                                                                          null) {
                                                                        widget
                                                                            .orderCubit
                                                                            .fetchOrder(context);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      OrdersHelper()
                                                                          .ordersPopupMenuList[j]),
                                                                ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 6, bottom: 15),
                                                  child: CommonHelper()
                                                      .dividerCommon(),
                                                ),

                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    state.data[i].serviceName,
                                                    style: mainFont.copyWith(
                                                        fontSize: 15),
                                                  ),
                                                ),

                                                //Divider
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15, bottom: 17),
                                                  child: CommonHelper()
                                                      .dividerCommon(),
                                                ),

                                                state.data[i].date != "00.00.00"
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15),
                                                        child: Column(
                                                          children: [
                                                            OrdersHelper()
                                                                .orderRow(
                                                              'assets/svg/calendar.svg',
                                                              'Tanggal',
                                                              state
                                                                  .data[i].date,
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 14),
                                                              child: CommonHelper()
                                                                  .dividerCommon(),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),

                                                state.data[i].schedule !=
                                                        "00.00.00"
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15),
                                                        child: Column(
                                                          children: [
                                                            OrdersHelper()
                                                                .orderRow(
                                                              'assets/svg/clock.svg',
                                                              'Waktu',
                                                              state.data[i]
                                                                  .schedule,
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 14),
                                                              child: CommonHelper()
                                                                  .dividerCommon(),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 0, 15, 15),
                                                  child:
                                                      OrdersHelper().orderRow(
                                                    'assets/svg/bill.svg',
                                                    'Tagihan',
                                                    moneyChanger(double.parse(
                                                        state.data[i].total)),
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ))),
                                ),
                              );
                      } else if (state is OrderLoading) {
                        return showLoading(cc.primaryColor);
                      } else {
                        return Text(state.toString());
                      }
                    })
                // for (int i = 0;
                //     i < provider.myServices.length;
                //     i++)
              ],
            ),
          ),
        ));
  }
}
