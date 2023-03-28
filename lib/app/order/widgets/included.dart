import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class Included extends StatelessWidget {
  const Included({Key? key, required this.data, required this.model})
      : super(key: key);

  final List<dynamic> data;
  final OrderVM model;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Column(
      children: [
        for (int i = 0; i < data.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    data[i]['include_service_title'],
                    style: mainFont.copyWith(
                      color: cc.greyParagraph,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 9,
                ),
                Row(
                  children: [
                    Text(
                      moneyChanger(
                          double.parse(data[i]['include_service_price'])),
                      style: mainFont.copyWith(
                        color: cc.greyPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Container(
                      width: 120,
                      height: 40,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: cc.borderColor, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          //decrease quanityt
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              model.onQtyDec(i);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
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
                                    '${data[i]['include_service_quantity']}',
                                    style: mainFont.copyWith(
                                        color: cc.greyPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ))),

                          //increase quantity
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              model.onQtyAdded(i);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: cc.successColor.withOpacity(.12),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
