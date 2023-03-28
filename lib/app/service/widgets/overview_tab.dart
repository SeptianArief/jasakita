// ignore_for_file: prefer_const_constructors

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/service/widgets/desc_in_html.dart';
import 'package:qixer/app/service/widgets/service_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class OverviewTab extends StatelessWidget {
  final ServiceDetail data;
  const OverviewTab({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Text(
        //   provider.serviceAllDetails.serviceDetails.description,
        //   style: mainFont.copyWith(
        //     color: cc.greyParagraph,
        //     fontSize: 14,
        //     height: 1.4,
        //   ),
        // ),
        DescInHtml(
          desc: data.description,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Keuntungan dari paket premium:',
          maxLines: 1,
          style: mainFont.copyWith(
              color: cc.greyFour, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        //checklist
        const SizedBox(
          height: 19,
        ),
        for (int i = 0; i < data.benefitsService.length; i++)
          ServiceHelper().checkListCommon(data.benefitsService[i]['benifits']),

        //FAQ ===============>
        (data.faq).isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'FAQ:',
                    maxLines: 1,
                    style: mainFont.copyWith(
                        color: cc.greyFour,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  //checklist
                  const SizedBox(
                    height: 15,
                  ),

                  for (int i = 0; i < data.faq.length; i++)
                    ExpandablePanel(
                      controller: ExpandableController(initialExpanded: false),
                      theme: const ExpandableThemeData(hasIcon: false),
                      header: Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                data.faq[i]['title'] ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: mainFont.copyWith(
                                    color: cc.greyFour,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: cc.greyParagraph,
                              ),
                            )
                          ],
                        ),
                      ),
                      collapsed: Text(''),
                      expanded: Container(
                          //Dropdown
                          margin: const EdgeInsets.only(bottom: 20, top: 8),
                          child: Column(
                            children: [Text(data.faq[i]['description'] ?? '-')],
                          )),
                    ),
                ],
              )
            : Container()
      ]),
    );
  }
}
