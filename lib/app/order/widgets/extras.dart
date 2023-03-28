import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/service/widgets/service_helper.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class Extras extends StatefulWidget {
  const Extras(
      {Key? key,
      required this.additionalServices,
      required this.serviceBenefits,
      required this.model})
      : super(key: key);

  final additionalServices;
  final serviceBenefits;
  final OrderVM model;

  @override
  State<Extras> createState() => _ExtrasState();
}

class _ExtrasState extends State<Extras> {
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHelper().titleCommon('${('Tambahan')}:'),
        const SizedBox(
          height: 17,
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          height: 145,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < widget.additionalServices.length; i++)
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    widget.model.onExtraTap(widget.additionalServices[i]['id']);
                    // if (selectedExtra.contains(i)) {
                    //   //if already added then remove
                    //   selectedExtra.remove(i);

                    //   Provider.of<PersonalizationService>(context,
                    //           listen: false)
                    //       .decreaseExtraItemPrice(context, i);
                    // } else {
                    //   selectedExtra.add(i);
                    //   Provider.of<PersonalizationService>(context,
                    //           listen: false)
                    //       .increaseExtraItemPrice(context, i);
                    // }

                    // setState(() {});
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        // alignment: Alignment.topLeft,
                        width: 200,
                        margin: const EdgeInsets.only(
                          right: 17,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: widget.model.isExtraSelected(
                                        widget.additionalServices[i]['id'])
                                    ? cc.primaryColor
                                    : cc.borderColor),
                            borderRadius: BorderRadius.circular(9)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.additionalServices[i]
                                  ['additional_service_title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: mainFont.copyWith(
                                color: cc.greyParagraph,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  moneyChanger(double.parse(
                                      widget.additionalServices[i]
                                          ['additional_service_price'])),
                                  style: mainFont.copyWith(
                                    color: cc.greyPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                //increase decrease button =======>
                                Container(
                                  width: 120,
                                  height: 40,
                                  margin: const EdgeInsets.only(top: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(
                                    //     color: widget.cc.borderColor, width: 1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      //decrease button
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          widget.model.decExtraQty(i);
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Colors.red.withOpacity(.12),
                                          ),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                            size: 19,
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                widget.additionalServices[i][
                                                    'additional_service_quantity'],
                                                style: mainFont.copyWith(
                                                    color: cc.greyPrimary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),

                                      //increase button
                                      Expanded(
                                          child: InkWell(
                                        onTap: () {
                                          widget.model.addExtraQty(i);
                                          // Provider.of<PersonalizationService>(
                                          //         context,
                                          //         listen: false)
                                          //     .increaseExtrasQty(
                                          //         i,
                                          //         selectedExtra.contains(i)
                                          //             ? true
                                          //             : false,
                                          //         context);
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: cc.successColor
                                                .withOpacity(.12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.add,
                                            color: cc.successColor,
                                            size: 19,
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                )
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Container(
                                //       margin: const EdgeInsets.only(top: 10),
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 17, vertical: 6),
                                //       decoration: BoxDecoration(
                                //           border: Border.all(
                                //               color: widget.cc.borderColor),
                                //           borderRadius:
                                //               BorderRadius.circular(5)),
                                //       child: Text(
                                //         'Add',
                                //         style: mainFont.copyWith(
                                //           color: widget.cc.greyFour,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.bold,
                                //         ),
                                //       ),
                                //     ),
                                //     CachedNetworkImage(
                                //       imageUrl:
                                //           'https://cdn.pixabay.com/photo/2013/07/12/17/41/lemon-152227_960_720.png',
                                //       errorWidget: (context, url, error) =>
                                //           const Icon(Icons.error),
                                //       fit: BoxFit.fitHeight,
                                //       height: 30,
                                //       width: 40,
                                //     )
                                //   ],
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.model.isExtraSelected(
                              widget.additionalServices[i]['id'])
                          ? Positioned(
                              right: 12,
                              top: -8,
                              child: CommonHelper().checkCircle())
                          : Container(),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 27,
        ),
        CommonHelper().titleCommon('${'Keuntungan Paket'}:'),
        const SizedBox(
          height: 17,
        ),
        for (int i = 0; i < widget.serviceBenefits.length; i++)
          ServiceHelper()
              .checkListCommon(widget.serviceBenefits[i]['benifits']),
      ],
    );
  }
}
