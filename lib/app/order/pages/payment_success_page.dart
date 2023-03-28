import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/landing/pages/landing_page.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String tanggal;
  final String jadwal;
  final String tax;
  final double taxPrice;
  final double totalPackage;
  final double subtotal;
  final double extraCharge;
  final double total;
  const PaymentSuccessPage(
      {Key? key,
      required this.paymentStatus,
      required this.tanggal,
      required this.jadwal,
      required this.tax,
      required this.taxPrice,
      required this.totalPackage,
      required this.subtotal,
      required this.extraCharge,
      required this.total})
      : super(key: key);

  final String paymentStatus;

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LandingPage()), (route) => false);

        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonHelper().appbarCommon('Pembayaran', context, () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LandingPage()),
                (route) => false);
          }),
          body: WillPopScope(
            onWillPop: () {
              // Navigator.pushReplacement<void, void>(
              //   context,
              //   MaterialPageRoute<void>(
              //     builder: (BuildContext context) => const LandingPage(),
              //   ),
              // );
              return Future.value(true);
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.none,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //success icon
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: cc.successColor,
                            size: 85,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            'Pembayaran Berhasil!',
                            style: mainFont.copyWith(
                                color: cc.greyFour,
                                fontSize: 21,
                                fontWeight: FontWeight.w600),
                          ),

                          //Date and Time =================>
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              top: 30,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 18),
                            decoration: BoxDecoration(
                                border: Border.all(color: cc.borderColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: BookingHelper().bdetailsContainer(
                                      'assets/svg/calendar.svg',
                                      'Tanggal',
                                      widget.tanggal),
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Expanded(
                                  child: BookingHelper().bdetailsContainer(
                                      'assets/svg/clock.svg',
                                      'Waktu',
                                      widget.jadwal),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          //payment details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Package fee and extra service =============>
                              BookingHelper().detailsPanelRow('Biaya Paket', 0,
                                  moneyChanger(widget.totalPackage)),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),

                          BookingHelper().detailsPanelRow('Biaya Tambahan', 0,
                              moneyChanger(widget.extraCharge)),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: CommonHelper().dividerCommon(),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //subtotal and tax =========>
                              BookingHelper().detailsPanelRow(
                                  'Subtotal', 0, moneyChanger(widget.subtotal)),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),

                          BookingHelper().detailsPanelRow(
                              'Pajak (+) ${widget.tax}%',
                              0,
                              moneyChanger(widget.taxPrice)),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: CommonHelper().dividerCommon(),
                          ),

                          //total and payment gateway =========>

                          //Total ====>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: mainFont.copyWith(
                                  color: cc.greyFour,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                moneyChanger(widget.total),
                                textAlign: TextAlign.right,
                                style: mainFont.copyWith(
                                  color: cc.greyFour,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          // sizedBox20(),
                          // //Gateway
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Payment gateway',
                          //       style: mainFont.copyWith(
                          //         color: cc.greyFour,
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.w400,
                          //       ),
                          //     ),
                          //     Text(
                          //       'Mobile',
                          //       textAlign: TextAlign.right,
                          //       style: mainFont.copyWith(
                          //         color: cc.greyFour,
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     )
                          //   ],
                          // ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: CommonHelper().dividerCommon(),
                          ),

                          //Payment status and order status ===========>
                          Row(
                            children: [
                              BookingHelper().colorCapsule('Status Pembayaran',
                                  widget.paymentStatus, cc.successColor),
                              const SizedBox(
                                width: 30,
                              ),
                              BookingHelper().colorCapsule(
                                  'Status Pesanan', 'Pending', cc.yellowColor)
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),

                      //
                    ]),
              ),
            ),
          )),
    );
  }
}
