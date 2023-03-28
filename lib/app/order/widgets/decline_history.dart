import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';

class DeclineHistory extends StatefulWidget {
  final String id;
  final OrderCubit orderCubit;
  const DeclineHistory({Key? key, required this.id, required this.orderCubit})
      : super(key: key);

  @override
  State<DeclineHistory> createState() => _DeclineHistoryState();
}

class _DeclineHistoryState extends State<DeclineHistory> {
  @override
  void initState() {
    widget.orderCubit.fetchDeclineHistory(context, orderId: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return BlocBuilder<OrderCubit, OrderState>(
        bloc: widget.orderCubit,
        builder: (context, state) {
          if (state is OrderLoading) {
            return showLoading(cc.primaryColor);
          } else if (state is OrderDeclineLoaded) {
            return Container(
              margin: const EdgeInsets.only(bottom: 25),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonHelper().titleCommon('Riwayat Penolakan'),
                  for (int i = 0;
                      i < state.data['decline_histories'].length;
                      i++)
                    Container(
                      margin: const EdgeInsets.only(top: 13),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHelper().titleCommon(
                                "Alasan Penolakan:  ${state.data['decline_histories'][i]['decline_reason']}",
                                fontsize: 14,
                                lineheight: 1.5),
                            SizedBox(height: 9),
                            CommonHelper().titleCommon('Buyer details:',
                                fontsize: 14, color: cc.successColor),
                            SizedBox(height: 8),
                            CommonHelper().paragraphCommon(
                                'Nama: ${state.data['seller_details'][0]['name']}',
                                TextAlign.left),
                            SizedBox(height: 4),
                            CommonHelper().paragraphCommon(
                                'Email: ${state.data['seller_details'][0]['email']}',
                                TextAlign.left),
                            SizedBox(height: 4),
                            CommonHelper().paragraphCommon(
                                'Nomor Handphone: ${state.data['seller_details'][0]['phone']}',
                                TextAlign.left),
                            SizedBox(height: 20),
                            CommonHelper().dividerCommon()
                          ]),
                    )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
