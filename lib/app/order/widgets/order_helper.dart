import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/pages/report_to_admin_page.dart';
import 'package:qixer/app/order/pages/wirte_review_page.dart';
import 'package:qixer/app/order/widgets/cancel_order_dialog.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrdersHelper {
  List ordersPopupMenuList = [
    'Ulas Pesanan',
    'Batalkan Pesanan',
    'Laporkan ke Admin'
  ];

  navigateMyOrders(BuildContext context,
      {required index, required serviceId, required orderId}) {
    if (index == 0) {
      return Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => WriteReviewPage(
            orderId: orderId.toString(),
          ),
        ),
      );
    } else if (index == 1) {
      OrdersHelper().cancelOrderPopup(context, orderId: orderId);
    } else if (index == 2) {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => WriteReportPage(
            serviceId: serviceId.toString(),
            orderId: orderId.toString(),
          ),
        ),
      );
    }
  }

  ConstantColors cc = ConstantColors();

  statusCapsule(String capsuleText, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
      decoration: BoxDecoration(
          color: color.withOpacity(.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        capsuleText,
        style: mainFont.copyWith(
            color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  statusCapsuleBordered(String capsuleText, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: cc.borderColor),
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)),
      child: Text(
        capsuleText,
        style: mainFont.copyWith(
            color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  ///
  orderRow(String icon, String title, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //icon
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: Row(children: [
            SvgPicture.asset(
              icon,
              height: 19,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              title,
              style: mainFont.copyWith(
                color: cc.greyFour,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ]),
        ),

        Flexible(
          child: Text(
            text,
            style: mainFont.copyWith(
              color: cc.greyFour,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  //cancel order popup
  //============>

  cancelOrderPopup(BuildContext context, {required orderId}) {
    return showDialog(
        context: context,
        builder: (context) {
          return CancelOrderDialog(orderId: orderId.toString());
        });
  }
}
