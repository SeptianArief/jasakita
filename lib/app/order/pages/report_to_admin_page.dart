// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/textarea_field.dart';

class WriteReportPage extends StatefulWidget {
  const WriteReportPage({
    Key? key,
    required this.serviceId,
    required this.orderId,
  }) : super(key: key);

  final serviceId;
  final orderId;
  @override
  State<WriteReportPage> createState() => _WriteReportPageState();
}

class _WriteReportPageState extends State<WriteReportPage> {
  double rating = 1;
  TextEditingController reportController = TextEditingController();

  bool reportLoading = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Laporan', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Laporan',
              style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 14,
            ),
            TextareaField(
              notesController: reportController,
              hintText: 'Mohon jelaskan permasalahannya',
            ),
            SizedBox(
              height: 20,
            ),
            CommonHelper().buttonOrange('Kirim Laporan', () {
              if (!reportLoading) {
                if (reportController.text.trim().isEmpty) {
                  FormHelper.showSnackbar(context,
                      data: 'Mohon mengisi laporan Anda',
                      colors: Colors.orange);
                } else {
                  setState(() {
                    reportLoading = true;
                  });

                  OrderService.reportToAdmin(context,
                          message: reportController.text,
                          orderId: widget.orderId,
                          serviceId: widget.serviceId)
                      .then((value) {
                    setState(() {
                      reportLoading = false;
                    });
                    if (value.status == RequestStatus.successRequest) {
                      FormHelper.showSnackbar(context,
                          data: 'Berhasil mengirim laporan',
                          colors: Colors.green);
                      Navigator.pop(context, true);
                    } else {
                      FormHelper.showSnackbar(context,
                          data: value.data ?? 'Gagal mengirim laporan',
                          colors: Colors.orange);
                    }
                  });
                }
              }
            }, isloading: reportLoading),
          ]),
        ),
      ),
    );
  }
}
