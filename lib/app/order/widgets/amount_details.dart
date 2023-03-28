import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/model/order_model.dart';
import 'package:qixer/app/order/pages/payment_webview_page.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/shared/common_helper.dart';

class AmountDetails extends StatelessWidget {
  final String url;
  final OrderDetailModel data;
  const AmountDetails({Key? key, required this.url, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 25),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(9)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CommonHelper().titleCommon('Rincian Biaya'),
            const SizedBox(
              height: 25,
            ),
            //Service row

            Container(
              child: BookingHelper()
                  .bRow('null', 'Biaya Paket', data.data.packageFee),
            ),

            Container(
              child: BookingHelper()
                  .bRow('null', 'Tambahan Layanan', data.data.extraService),
            ),

            Container(
              child:
                  BookingHelper().bRow('null', 'Sub total', data.data.subTotal),
            ),

            Container(
              child: BookingHelper().bRow('null', 'Pajak', data.data.tax),
            ),

            Container(
              child: BookingHelper().bRow('null', 'Total', data.data.total),
            ),

            Container(
              child: BookingHelper().bRow(
                  'null',
                  'Status Pembayaran',
                  data.data.paymentStatus == 'complete'
                      ? 'Selesai'
                      : data.data.paymentStatus),
            ),

            Container(
              child: BookingHelper().bRow(
                  'null',
                  'Metode Pembayaran',
                  data.data.paymentGateway == null
                      ? 'Xendit'
                      : data.data.paymentGateway!.replaceAll('_', ' '),
                  lastBorder: false),
            ),

            if (data.data.paymentStatus == 'pending' &&
                data.data.paymentGateway != "cash_on_delivery" &&
                data.data.paymentGateway != "manual_payment")
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: CommonHelper().buttonOrange('Bayar Sekarang', () {
                  //At first, set the address details
                  // Provider.of<BookService>(context, listen: false)
                  //     .setDeliveryDetailsBasedOnProfile(context);

                  // //set if online or offline
                  // var isOnline = provider.orderDetails.isOrderOnline;
                  // Provider.of<PersonalizationService>(context,
                  //         listen: false)
                  //     .setOnlineOffline(isOnline);

                  // //set total amount
                  // var total = double.parse(
                  //     removeDollar(provider.orderDetails.total));

                  // if (isOnline == 1) {
                  //   Provider.of<BookConfirmationService>(context,
                  //           listen: false)
                  //       .setTotalOnlineService(total);
                  // } else {
                  //   Provider.of<BookConfirmationService>(context,
                  //           listen: false)
                  //       .setTotalOfflineService(total);
                  // }

                  // // set order id
                  // Provider.of<PlaceOrderService>(context, listen: false)
                  //     .setOrderId(provider.orderDetails.id);
                  //

                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => UserPaymentWebview(
                        url: url,
                        extraCharge: double.parse(data.data.extraService
                            .replaceAll(',', '')
                            .substring(4)),
                        jadwal: data.data.scheulde,
                        subtotal: double.parse(data.data.subTotal
                            .replaceAll(',', '')
                            .substring(4)),
                        tanggal: data.data.date,
                        tax: '',
                        taxPrice: double.parse(
                            data.data.tax.replaceAll(',', '').substring(4)),
                        total: double.parse(
                            data.data.total.replaceAll(',', '').substring(4)),
                        totalPackage: double.parse(data.data.packageFee
                            .replaceAll(',', '')
                            .substring(4)),
                      ),
                    ),
                  );
                }, paddingVerticle: 16),
              )
          ]),
        ),
      ],
    );
  }
}
