import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/model/order_model.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/shared/common_helper.dart';

class SellerDetails extends StatelessWidget {
  final OrderDetailModel data;
  const SellerDetails({Key? key, required this.data}) : super(key: key);

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
            CommonHelper().titleCommon('Detil Vendor'),
            const SizedBox(
              height: 25,
            ),
            //Service row

            Container(
              child: BookingHelper().bRow('null', 'Nama', data.seller.name),
            ),

            Container(
              child: BookingHelper().bRow('null', 'Email', data.seller.email),
            ),

            Container(
              child: BookingHelper()
                  .bRow('null', 'Nomor Handphone', data.seller.phone),
            ),

            Container(
              child: BookingHelper().bRow('null', 'Alamat', data.seller.address,
                  lastBorder: false),
            ),
          ]),
        )
      ],
    );
  }
}
