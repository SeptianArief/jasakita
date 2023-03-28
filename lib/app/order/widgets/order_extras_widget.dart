import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class OrderExtras extends StatelessWidget {
  const OrderExtras({Key? key, required this.orderId, required this.sellerId})
      : super(key: key);
  final orderId;
  final sellerId;

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHelper().titleCommon('Tambahan'),
          const SizedBox(
            height: 20,
          ),
          // for (int i = 0; i < provider.orderExtra.length; i++)
          //   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //     CommonHelper()
          //         .titleCommon(provider.orderExtra[i].title, fontsize: 15),
          //     SizedBox(height: 5),
          //     CommonHelper().paragraphCommon(
          //         'Unit price: \$${provider.orderExtra[i].price.toStringAsFixed(2)}    Quantity: ${provider.orderExtra[i].quantity}    Total: \$${provider.orderExtra[i].total.toStringAsFixed(2)}',
          //         TextAlign.left),
          //     SizedBox(height: 12),

          //     //0=pending,1=accept,2=decline
          //     if (provider.orderExtra[i].status == 0)
          //       Row(
          //         children: [
          //           Expanded(
          //               child: CommonHelper().buttonOrange('Decline', () {
          //             OrderDetailsHelper().deletePopup(context,
          //                 extraId: provider.orderExtra[i].id, orderId: orderId);
          //           }, bgColor: Colors.red, paddingVerticle: 14)),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           Expanded(
          //               child: CommonHelper().buttonOrange('Accept', () {
          //             provider.setExtraDetails(
          //                 orderId: orderId,
          //                 extraId: provider.orderExtra[i].id,
          //                 extraPrice:
          //                     provider.orderExtra[i].total.toStringAsFixed(2),
          //                 sellerId: sellerId);

          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const PaymentChoosePage(
          //                         isFromOrderExtraAccept: true,
          //                       )),
          //             );
          //           }, bgColor: cc.successColor, paddingVerticle: 15)),
          //         ],
          //       ),
          //     SizedBox(height: 22)
          //   ])
        ],
      ),
    );
  }
}
