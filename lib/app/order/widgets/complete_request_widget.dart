import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/home/services/service_service.dart';
import 'package:qixer/app/order/model/order_model.dart';
import 'package:qixer/app/order/pages/decline_order_page.dart';
import 'package:qixer/app/order/widgets/order_helper.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';

class CompleteRequest extends StatefulWidget {
  final OrderDetailModel data;
  final String orderId;
  final Function refreshDecline;
  const CompleteRequest(
      {Key? key,
      required this.orderId,
      required this.refreshDecline,
      required this.data})
      : super(key: key);

  @override
  State<CompleteRequest> createState() => _CompleteRequestState();
}

class _CompleteRequestState extends State<CompleteRequest> {
  bool markLoading = false;

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();
    return widget.data.data.orderCompleteRequest != 0
        ? Column(
            children: [
              // order_complete_request == 0 (No Request Create)
              // order_complete_request == 1 (Approve, Decline)
              // order_complete_request == 2 ( Completed)
              // order_complete_request == 3 (Request Decline, View History)

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHelper().titleCommon('Selesaikan Pesanan'),
                      const SizedBox(
                        height: 15,
                      ),
                      //Declined
                      //==========>
                      if (widget.data.data.orderCompleteRequest == 3)
                        OrdersHelper()
                            .statusCapsule('Declined', cc.warningColor),

                      //Completed
                      //==========>
                      if (widget.data.data.orderCompleteRequest == 2)
                        OrdersHelper()
                            .statusCapsule('Order completed', cc.successColor),

                      //accept reject button
                      //==========>
                      if (widget.data.data.orderCompleteRequest == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHelper().paragraphCommon(
                                'Vendor meminta untuk menyelesaikan pesanan',
                                TextAlign.left,
                                fontsize: 16),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: CommonHelper().buttonOrange(
                                  'Tolak',
                                  () async {
                                    bool? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DeclineOrderPage(
                                                fcmToken: widget
                                                    .data.seller.firebaseToken,
                                                orderId: widget.orderId,
                                                sellerId: widget.data.seller.id
                                                    .toString(),
                                              )),
                                    );

                                    if (result != null) {
                                      widget.refreshDecline();
                                    }
                                  },
                                  bgColor: Colors.red,
                                )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: CommonHelper()
                                        .buttonOrange('Selesaikan', () {
                                  setState(() {
                                    markLoading = true;
                                  });

                                  ServiceService.finishOrder(context,
                                          orderId: widget.orderId)
                                      .then((value) {
                                    setState(() {
                                      markLoading = false;
                                    });
                                    if (value.status ==
                                        RequestStatus.successRequest) {
                                      ProfileState profileState =
                                          BlocProvider.of<ProfileCubit>(context)
                                              .state;
                                      if (profileState is ProfileLoaded) {
                                        PushNotificationService()
                                            .sendNotificationToSellerByToken(
                                                context,
                                                token: widget
                                                    .data.seller.firebaseToken,
                                                title:
                                                    "${profileState.data.detail.name} telah menyelesaikan pesanan",
                                                body:
                                                    'Id Pesanan: ${widget.orderId}');
                                      }

                                      FormHelper.showSnackbar(context,
                                          data:
                                              'Berhasil menyelesaikan pesanan',
                                          colors: Colors.green);
                                      Navigator.pop(context, true);
                                    } else {
                                      FormHelper.showSnackbar(context,
                                          data:
                                              'Gagal menyelesaikan pesanan, mohon coba lagi',
                                          colors: Colors.orange);
                                    }
                                  });
                                },
                                            bgColor: cc.successColor,
                                            isloading: markLoading))
                              ],
                            )
                          ],
                        ),
                      //Service row
                    ]),
              ),
            ],
          )
        : Container();
  }
}
