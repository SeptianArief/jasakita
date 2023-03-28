// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/services/service_service.dart';
import 'package:qixer/app/order/pages/order_page.dart';
import 'package:qixer/app/service/pages/service_detail_page.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel data;
  final bool isSplit;
  const ServiceCard({Key? key, required this.data, this.isSplit = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    Widget splitWidget({required Widget child}) {
      if (isSplit) {
        return FractionallySizedBox(widthFactor: 0.49, child: child);
      } else {
        return Container(width: 150, child: child);
      }
    }

    return splitWidget(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ServiceDetailsPage(
                        serviceId: data.id.toString(),
                      )));
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.black12,
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(data.image))),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                color: cc.primaryColor,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                        child: Text(
                      data.areaName,
                      style:
                          mainFont.copyWith(fontSize: 10, color: Colors.white),
                    ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                      child: Text(
                        data.title,
                        style: mainFont.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    Text(
                      'Harga Mulai',
                      style: mainFont.copyWith(fontSize: 10),
                    ),
                    Text(
                      moneyChanger(double.parse(data.price)),
                      style: mainFont.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        data.seller!.image == placeHolderUrl
                            ? Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/avatar.png'))),
                              )
                            : Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(data.seller!.image))),
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.seller!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: mainFont.copyWith(
                                  fontSize: 11, color: Colors.black87),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      Icons.star,
                                      size: 10,
                                      color: (index + 1) <=
                                              double.parse(data.reviewSummary)
                                          ? Colors.amber
                                          : Colors.grey,
                                    );
                                  }),
                                ),
                                Text(
                                  ' (${data.reviewSummary})',
                                  style: mainFont.copyWith(
                                      fontSize: 9, color: Colors.black54),
                                )
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        EasyLoading.show();
                        ServiceService.fetchDetailService(context,
                                id: data.id.toString())
                            .then((value) {
                          EasyLoading.dismiss();
                          if (value.status == RequestStatus.successRequest) {
                            ServiceDetail data = value.data;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ServicePersonalizationPage(
                                          serviceId: data.id.toString(),
                                          brands: data.brands,
                                        )));
                          } else {
                            FormHelper.showSnackbar(context,
                                data: 'Gagal mengambil data, mohon coba lagi',
                                colors: Colors.orange);
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: cc.primaryColor),
                        child: Text(
                          'Pesan',
                          style: mainFont.copyWith(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCardContents extends StatelessWidget {
  const ServiceCardContents(
      {Key? key,
      required this.cc,
      required this.imageLink,
      required this.title,
      required this.sellerName,
      required this.rating,
      required this.price,
      required this.asProvider})
      : super(key: key);

  final ConstantColors cc;
  final imageLink;
  final title;
  final sellerName;
  final rating;
  final price;
  final asProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            //service image
            CommonHelper().profileImage(imageLink, 75, 78),
            rating != 0.0
                ? Positioned(
                    bottom: -13,
                    left: 12,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: const Color(0xffFFC300),
                          borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Row(children: [
                        Icon(
                          Icons.star_border,
                          color: cc.greyFour,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          rating.toString(),
                          style: mainFont.copyWith(
                              color: cc.greyFour,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        )
                      ]),
                    ))
                : Container(),
          ],
        ),
        const SizedBox(
          width: 13,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //service name ======>
              Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),

              //Author name
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '${asProvider.getString('by')}:',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mainFont.copyWith(
                      color: cc.greyFour.withOpacity(.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    sellerName ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mainFont.copyWith(
                      color: cc.greyFour,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
