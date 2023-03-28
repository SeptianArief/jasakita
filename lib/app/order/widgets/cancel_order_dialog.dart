import 'package:flutter/material.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';

class CancelOrderDialog extends StatefulWidget {
  final String orderId;
  const CancelOrderDialog({Key? key, required this.orderId}) : super(key: key);

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool cancelLoading = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Container(
            margin: const EdgeInsets.only(top: 22),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    spreadRadius: -2,
                    blurRadius: 13,
                    offset: const Offset(0, 13)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Apakah Anda yakin?',
                  style: mainFont.copyWith(color: cc.greyPrimary, fontSize: 17),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CommonHelper().borderButtonOrange('Tidak', () {
                      Navigator.pop(context);
                    })),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: CommonHelper().buttonOrange('Ya', () {
                      if (!cancelLoading) {
                        setState(() {
                          cancelLoading = true;
                        });
                        OrderService.cancelOrder(context,
                                orderId: widget.orderId)
                            .then((value) {
                          setState(() {
                            cancelLoading = false;
                          });
                          if (value.status == RequestStatus.successRequest) {
                            FormHelper.showSnackbar(context,
                                data: 'Berhasil membatalkan pesanan',
                                colors: Colors.green);
                            Navigator.pop(context);
                          } else {
                            FormHelper.showSnackbar(context,
                                data: value.data ?? 'Gagal membatalkan pesanan',
                                colors: Colors.orange);
                          }
                        });
                      }
                    }, isloading: cancelLoading)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
