import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderDetailsPanel extends StatefulWidget {
  final PanelController panelController;
  final OrderVM model;
  const OrderDetailsPanel(
      {Key? key, required this.panelController, required this.model})
      : super(key: key);

  @override
  State<OrderDetailsPanel> createState() => _OrderDetailsPanelState();
}

class _OrderDetailsPanelState extends State<OrderDetailsPanel>
    with TickerProviderStateMixin {
  ConstantColors cc = ConstantColors();
  FocusNode couponFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  TextEditingController couponController = TextEditingController();
  bool loadingFirstTime = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 17, bottom: 6),
          child: InkWell(
            onTap: () {
              try {
                if (widget.panelController.isPanelOpen) {
                  widget.panelController.close();
                } else {
                  widget.panelController.open();
                }
              } catch (e) {}
            },
            child: Column(
              children: [
                widget.model.isPanelOpened == false
                    ? Text(
                        'Tarik Keatas untuk Detilnya',
                        style: mainFont.copyWith(
                          color: cc.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        'Sembunyikan Detil',
                        style: mainFont.copyWith(
                          color: cc.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                widget.model.isPanelOpened == false
                    ? Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: cc.primaryColor,
                      )
                    : Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: cc.primaryColor,
                      ),
              ],
            ),
          ),
        ),
        Expanded(
            child: BlocBuilder<ServiceCubit, ServiceState>(
                bloc: widget.model.serviceCubit,
                builder: (context, state) {
                  if (state is ServiceBookingLoaded) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: CommonHelper().dividerCommon(),
                            ),

                            //service list ===================>
                            widget.model.isPanelOpened == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // icludes list ======>
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper()
                                              .labelCommon('Layanan Paket'),
                                          const SizedBox(
                                            height: 5,
                                          ),

                                          //Service included list =============>
                                          for (int i = 0;
                                              i <
                                                  state.data.serviceIncluded
                                                      .length;
                                              i++)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: BookingHelper().detailsPanelRow(
                                                  state.data.serviceIncluded[i]
                                                      ['include_service_title'],
                                                  int.parse(state.data
                                                          .serviceIncluded[i][
                                                      'include_service_quantity']),
                                                  moneyChanger(double.parse(state
                                                          .data
                                                          .serviceIncluded[i][
                                                      'include_service_price']))),
                                            ),

                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 3, bottom: 15),
                                            child:
                                                CommonHelper().dividerCommon(),
                                          ),
                                          //Package fee
                                          BookingHelper().detailsPanelRow(
                                              'Biaya Paket',
                                              0,
                                              moneyChanger(double.parse(
                                                  state.data.price))),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      Column(
                                        children: [
                                          widget.model.selectedBrand == null
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Brand',
                                                        style:
                                                            mainFont.copyWith(
                                                          color: cc.greyFour,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.model
                                                            .selectedBrand!,
                                                        style:
                                                            mainFont.copyWith(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black87),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Catatan',
                                                style: mainFont.copyWith(
                                                  color: cc.greyFour,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4),
                                                child: Text(
                                                  widget.model.notesController
                                                          .text.isEmpty
                                                      ? '-'
                                                      : widget.model
                                                          .notesController.text,
                                                  style: mainFont.copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      //Extra service =============>

                                      widget.model.selectedExtra.isEmpty
                                          ? Container()
                                          : Column(
                                              children: [
                                                CommonHelper().labelCommon(
                                                    'Layanan tambahan'),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                // Column(
                                                //   children: List.generate(
                                                //       state
                                                //           .data
                                                //           .serviceAdditional
                                                //           .length, (index) {
                                                //     bool showData = widget
                                                //         .model.selectedExtra
                                                //         .contains(state.data
                                                //                 .serviceAdditional[
                                                //             index]['id']);

                                                //     return showData
                                                //         ? Container(
                                                //             margin:
                                                //                 const EdgeInsets
                                                //                         .only(
                                                //                     bottom: 15),
                                                //             child: BookingHelper().detailsPanelRow(
                                                //                 state.data.serviceAdditional[
                                                //                         index][
                                                //                     'additional_service_title'],
                                                //                 state.data.serviceAdditional[
                                                //                         index][
                                                //                     'additional_service_quantity'],
                                                //                 moneyChanger(double.parse(state
                                                //                         .data
                                                //                         .serviceAdditional[index]
                                                //                     ['additional_service_price']))),
                                                //           )
                                                //         : Container();
                                                //   }),
                                                // )
                                              ],
                                            ),

                                      //==================>
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 3, bottom: 15),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      //total of extras
                                      BookingHelper().detailsPanelRow(
                                          'Biaya Layanan Tambahan',
                                          0,
                                          moneyChanger(
                                              widget.model.getExtraCharge())),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      //Sub total and tax ============>
                                      //Sub total
                                      Column(
                                        children: [
                                          BookingHelper().detailsPanelRow(
                                              'Subtotal',
                                              0,
                                              moneyChanger(
                                                  widget.model.getTotalPrice() +
                                                      widget.model
                                                          .getExtraCharge())),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),

                                      //tax
                                      BookingHelper().detailsPanelRow(
                                          'Pajak(+) ${state.data.tax}%',
                                          0,
                                          moneyChanger(
                                              widget.model.getTaxCharge())),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 12),
                                        child: CommonHelper().dividerCommon(),
                                      ),

                                      //Coupon ===>

                                      BookingHelper().detailsPanelRow(
                                          'Kupon',
                                          0,
                                          moneyChanger(
                                              widget.model.getDiscount())),

                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 15, bottom: 12),
                                        child: CommonHelper().dividerCommon(),
                                      ),
                                    ],
                                  )
                                : Container(),

                            //total ===>

                            BookingHelper().detailsPanelRow(
                                'Total',
                                0,
                                moneyChanger(widget.model.getTotalPrice() +
                                    widget.model.getExtraCharge() +
                                    widget.model.getTaxCharge() -
                                    widget.model.getDiscount())),

                            widget.model.isPanelOpened == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CommonHelper().labelCommon("Kode Kupon"),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    // color: const Color(0xfff2f2f2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: TextFormField(
                                                  controller: couponController,
                                                  style: mainFont.copyWith(
                                                      fontSize: 14),
                                                  focusNode: couponFocus,
                                                  decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors()
                                                                  .greyFive),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  7)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors()
                                                                  .primaryColor)),
                                                      errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors()
                                                                  .warningColor)),
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: ConstantColors().primaryColor)),
                                                      hintText: 'Masukkan Kode Kupon',
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
                                                )),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 15),
                                            width: 100,
                                            child: CommonHelper().buttonOrange(
                                                'Terapkan', () {
                                              if (couponController
                                                  .text.isNotEmpty) {
                                                widget.model.applyCoupon(
                                                    context,
                                                    coupon: couponController
                                                        .text, onCallback: () {
                                                  setState(() {});
                                                });
                                                // if (couponProvider.isloading ==
                                                //     false) {
                                                //   // couponController.clear();
                                                //   couponProvider.getCouponDiscount(
                                                //       couponController.text,
                                                //       //total amount
                                                //       bcProvider
                                                //           .totalPriceAfterAllcalculation,
                                                //       //seller id
                                                //       Provider.of<BookService>(
                                                //               context,
                                                //               listen: false)
                                                //           .sellerId,
                                                //       //context
                                                //       context);
                                                // }
                                              }
                                            },
                                                isloading:
                                                    widget.model.couponLoading),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(),

                            //Buttons
                            const SizedBox(
                              height: 20,
                            ),
                            CommonHelper()
                                .buttonOrange('Lanjutkan ke Pembayaran', () {
                              widget.model.payment(context, onCallback: () {
                                setState(() {});
                              });
                            }, isloading: widget.model.paymentLoading),

                            const SizedBox(
                              height: 105,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                }))
        // BlocBuilder<ServiceCubit, ServiceState>(
        //     bloc: widget.model.serviceCubit,
        //     builder: (context, state) {
        //       if (state is ServiceBookingLoaded) {
        //         return Expanded(
        //           child: Listener(
        //             onPointerDown: (_) {
        //               FocusScopeNode currentFocus = FocusScope.of(context);
        //               if (!currentFocus.hasPrimaryFocus) {
        //                 currentFocus.focusedChild?.unfocus();
        //               }
        //             },
        //             child: SingleChildScrollView(
        //               controller: _scrollController,
        //               child: Container(
        //                 padding: const EdgeInsets.symmetric(horizontal: 25),
        //                 child: AnimatedSize(
        //                   duration: const Duration(milliseconds: 250),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Container(
        //                         margin: const EdgeInsets.only(bottom: 20),
        //                         child: CommonHelper().dividerCommon(),
        //                       ),

        //                       //service list ===================>
        //                       widget.model.isPanelOpened == true
        //                           ? Column(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 // icludes list ======>
        //                                 Column(
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     CommonHelper()
        //                                         .labelCommon('Layanan Paket'),
        //                                     const SizedBox(
        //                                       height: 5,
        //                                     ),

        //                                     //Service included list =============>
        //                                     for (int i = 0;
        //                                         i <
        //                                             state.data.serviceIncluded
        //                                                 .length;
        //                                         i++)
        //                                       Container(
        //                                         margin: const EdgeInsets.only(
        //                                             bottom: 10),
        //                                         child: BookingHelper().detailsPanelRow(
        //                                             state.data
        //                                                     .serviceIncluded[i][
        //                                                 'include_service_title'],
        //                                             state.data
        //                                                     .serviceIncluded[i][
        //                                                 'include_service_quantity'],
        //                                             state.data
        //                                                     .serviceIncluded[i][
        //                                                 'include_service_price']),
        //                                       ),

        //                                     Column(
        //                                       children: [
        //                                         widget.model.selectedBrand ==
        //                                                 null
        //                                             ? Container()
        //                                             : Container(
        //                                                 margin: EdgeInsets.only(
        //                                                     bottom: 10),
        //                                                 child: Row(
        //                                                   mainAxisAlignment:
        //                                                       MainAxisAlignment
        //                                                           .spaceBetween,
        //                                                   children: [
        //                                                     Text(
        //                                                       'Brand',
        //                                                       style: mainFont
        //                                                           .copyWith(
        //                                                         color:
        //                                                             cc.greyFour,
        //                                                         fontSize: 14,
        //                                                         fontWeight:
        //                                                             FontWeight
        //                                                                 .w400,
        //                                                       ),
        //                                                     ),
        //                                                     Text(
        //                                                       widget.model
        //                                                           .selectedBrand!,
        //                                                       style: mainFont.copyWith(
        //                                                           fontSize: 14,
        //                                                           color: Colors
        //                                                               .black87),
        //                                                     )
        //                                                   ],
        //                                                 ),
        //                                               ),
        //                                         Row(
        //                                           mainAxisAlignment:
        //                                               MainAxisAlignment
        //                                                   .spaceBetween,
        //                                           children: [
        //                                             Text(
        //                                               'Catatan',
        //                                               style: mainFont.copyWith(
        //                                                 color: cc.greyFour,
        //                                                 fontSize: 14,
        //                                                 fontWeight:
        //                                                     FontWeight.w400,
        //                                               ),
        //                                             ),
        //                                             Container(
        //                                               constraints: BoxConstraints(
        //                                                   maxWidth: MediaQuery.of(
        //                                                               context)
        //                                                           .size
        //                                                           .width *
        //                                                       0.4),
        //                                               child: Text(
        //                                                 widget
        //                                                         .model
        //                                                         .notesController
        //                                                         .text
        //                                                         .isEmpty
        //                                                     ? '-'
        //                                                     : widget
        //                                                         .model
        //                                                         .notesController
        //                                                         .text,
        //                                                 style:
        //                                                     mainFont.copyWith(
        //                                                         fontSize: 14,
        //                                                         fontWeight:
        //                                                             FontWeight
        //                                                                 .bold,
        //                                                         color: Colors
        //                                                             .black87),
        //                                               ),
        //                                             )
        //                                           ],
        //                                         ),
        //                                       ],
        //                                     ),
        //                                     SizedBox(
        //                                       height: 15,
        //                                     ),

        //                                     Container(
        //                                       margin: const EdgeInsets.only(
        //                                           top: 3, bottom: 15),
        //                                       child: CommonHelper()
        //                                           .dividerCommon(),
        //                                     ),
        //                                     //Package fee
        //                                     BookingHelper().detailsPanelRow(
        //                                         'Biaya Paket',
        //                                         0,
        //                                         state.data.price),
        //                                     const SizedBox(
        //                                       height: 30,
        //                                     ),
        //                                   ],
        //                                 ),

        //                                 //Extra service =============>

        //                                 CommonHelper()
        //                                     .labelCommon('Layanan tambahan'),
        //                                 const SizedBox(
        //                                   height: 5,
        //                                 ),
        //                                 // for (int i = 0;
        //                                 //     i <
        //                                 //         state.data.serviceAdditional
        //                                 //             .length;
        //                                 //     i++)
        //                                 //   widget.model.selectedExtra.contains(
        //                                 //           state.data
        //                                 //                   .serviceAdditional[i]
        //                                 //               ['id'])
        //                                 //       ? Container(
        //                                 //           margin: const EdgeInsets.only(
        //                                 //               bottom: 15),
        //                                 //           child: BookingHelper()
        //                                 //               .detailsPanelRow(
        //                                 //                   pProvider
        //                                 //                           .extrasList[i]
        //                                 //                       ['title'],
        //                                 //                   pProvider
        //                                 //                           .extrasList[i]
        //                                 //                       ['qty'],
        //                                 //                   pProvider
        //                                 //                       .extrasList[i]
        //                                 //                           ['price']
        //                                 //                       .toString()),
        //                                 //         )
        //                                 //       : Container(),

        //                                 //==================>
        //                                 Container(
        //                                   margin: const EdgeInsets.only(
        //                                       top: 3, bottom: 15),
        //                                   child: CommonHelper().dividerCommon(),
        //                                 ),

        //                                 //total of extras
        //                                 BookingHelper().detailsPanelRow(
        //                                     'Biaya Layanan Tambahan',
        //                                     0,
        //                                     'extra'),
        //                                 Container(
        //                                   margin: const EdgeInsets.only(
        //                                       top: 15, bottom: 15),
        //                                   child: CommonHelper().dividerCommon(),
        //                                 ),

        //                                 //Sub total and tax ============>
        //                                 //Sub total
        //                                 // Column(
        //                                 //   children: [
        //                                 //     BookingHelper().detailsPanelRow(
        //                                 //         'Subtotal',
        //                                 //         0,
        //                                 //         bcProvider
        //                                 //             .calculateSubtotal(
        //                                 //                 pProvider.includedList,
        //                                 //                 pProvider.extrasList)
        //                                 //             .toString()),
        //                                 //     const SizedBox(
        //                                 //       height: 20,
        //                                 //     ),
        //                                 //   ],
        //                                 // ),

        //                                 //tax
        //                                 // BookingHelper().detailsPanelRow(
        //                                 //     'Pajak(+) ${pProvider.tax}%',
        //                                 //     0,
        //                                 //     bcProvider
        //                                 //         .calculateTax(
        //                                 //           pProvider.tax,
        //                                 //           pProvider.includedList,
        //                                 //           pProvider.extrasList,
        //                                 //         )
        //                                 //         .toString()),
        //                                 Container(
        //                                   margin: const EdgeInsets.only(
        //                                       top: 15, bottom: 12),
        //                                   child: CommonHelper().dividerCommon(),
        //                                 ),

        //                                 //Coupon ===>

        //                                 // BookingHelper().detailsPanelRow(
        //                                 //     'Kupon',
        //                                 //     0,
        //                                 //     couponService.couponDiscount
        //                                 //         .toString()),

        //                                 Container(
        //                                   margin: const EdgeInsets.only(
        //                                       top: 15, bottom: 12),
        //                                   child: CommonHelper().dividerCommon(),
        //                                 ),
        //                               ],
        //                             )
        //                           : Container(),

        //                       //total ===>

        //                       BookingHelper()
        //                           .detailsPanelRow('Total', 0, 'total'),

        //                       widget.model.isPanelOpened == true
        //                           ? Column(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 SizedBox(
        //                                   height: 20,
        //                                 ),
        //                                 CommonHelper()
        //                                     .labelCommon("Kode Kupon"),
        //                                 Row(
        //                                   children: [
        //                                     Expanded(
        //                                       child: Container(
        //                                           decoration: BoxDecoration(
        //                                               // color: const Color(0xfff2f2f2),
        //                                               borderRadius:
        //                                                   BorderRadius.circular(
        //                                                       10)),
        //                                           child: TextFormField(
        //                                             controller:
        //                                                 couponController,
        //                                             style: mainFont.copyWith(
        //                                                 fontSize: 14),
        //                                             focusNode: couponFocus,
        //                                             decoration: InputDecoration(
        //                                                 enabledBorder: OutlineInputBorder(
        //                                                     borderSide: BorderSide(
        //                                                         color: ConstantColors()
        //                                                             .greyFive),
        //                                                     borderRadius:
        //                                                         BorderRadius.circular(
        //                                                             7)),
        //                                                 focusedBorder: OutlineInputBorder(
        //                                                     borderSide: BorderSide(
        //                                                         color: ConstantColors()
        //                                                             .primaryColor)),
        //                                                 errorBorder: OutlineInputBorder(
        //                                                     borderSide: BorderSide(
        //                                                         color: ConstantColors()
        //                                                             .warningColor)),
        //                                                 focusedErrorBorder:
        //                                                     OutlineInputBorder(
        //                                                         borderSide: BorderSide(
        //                                                             color: ConstantColors().primaryColor)),
        //                                                 hintText: 'Masukkan Kode Kupon',
        //                                                 contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
        //                                           )),
        //                                     ),
        //                                     Container(
        //                                       margin: const EdgeInsets.only(
        //                                           left: 15),
        //                                       width: 100,
        //                                       child: CommonHelper()
        //                                           .buttonOrange('Terapkan', () {
        //                                         if (couponController
        //                                             .text.isNotEmpty) {
        //                                           // if (couponProvider.isloading ==
        //                                           //     false) {
        //                                           //   // couponController.clear();
        //                                           //   couponProvider.getCouponDiscount(
        //                                           //       couponController.text,
        //                                           //       //total amount
        //                                           //       bcProvider
        //                                           //           .totalPriceAfterAllcalculation,
        //                                           //       //seller id
        //                                           //       Provider.of<BookService>(
        //                                           //               context,
        //                                           //               listen: false)
        //                                           //           .sellerId,
        //                                           //       //context
        //                                           //       context);
        //                                           // }
        //                                         }
        //                                       }, isloading: false),
        //                                     )
        //                                   ],
        //                                 ),
        //                               ],
        //                             )
        //                           : Container(),

        //                       //Buttons
        //                       const SizedBox(
        //                         height: 20,
        //                       ),
        //                       //TODO uncomment this to make the panel work again
        //                       Row(
        //                         children: [
        //                           // widget.panelController.isPanelClosed
        //                           //     ? Expanded(
        //                           //         child: CommonHelper().borderButtonOrange(
        //                           //             'Apply coupon', () {
        //                           //           widget.panelController.open();
        //                           //           couponFocus.requestFocus();
        //                           //           Future.delayed(
        //                           //               const Duration(milliseconds: 900),
        //                           //               () {
        //                           //             _scrollController.animateTo(
        //                           //               355,
        //                           //               duration: const Duration(
        //                           //                   milliseconds: 600),
        //                           //               curve: Curves.fastOutSlowIn,
        //                           //             );
        //                           //           });
        //                           //         }),
        //                           //       )
        //                           //     : Container(),
        //                           // widget.panelController.isPanelClosed
        //                           //     ? const SizedBox(
        //                           //         width: 20,
        //                           //       )
        //                           //     : Container(),
        //                           CommonHelper().buttonOrange(
        //                               'Lanjutkan ke Pembayaran', () {
        //                             // EasyLoading.show();
        //                             // Provider.of<BookService>(context, listen: false)
        //                             //     .bookingService(context)
        //                             //     .then((value) {
        //                             //   EasyLoading.dismiss();
        //                             //   if (value != null) {
        //                             //     // Navigator.push(
        //                             //     //     context,
        //                             //     //     MaterialPageRoute(
        //                             //     //         builder: (_) =>
        //                             //     //             UserPaymentWebview(url: value)));
        //                             //   }
        //                             // });
        //                           })
        //                         ],
        //                       ),
        //                       const SizedBox(
        //                         height: 105,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         );
        //       } else {
        //         return Container();
        //       }
        //     }),
      ],
    );
  }
}
