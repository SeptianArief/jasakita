// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/pages/vendor_detail_page.dart';
import 'package:qixer/app/service/widgets/service_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class ServiceDetailsTop extends StatelessWidget {
  final ServiceDetail data;
  const ServiceDetailsTop({
    Key? key,
    required this.data,
    required this.cc,
  }) : super(key: key);

  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    String getRating(List<dynamic> reviewData) {
      double totalCount = 0;

      reviewData.forEach((element) {
        totalCount = totalCount + double.parse(element['rating']);
      });

      return (totalCount / reviewData.length).toStringAsFixed(1);
    }

    return Column(
      children: [
        //title author price details
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            ServiceTitleAndUser(
              cc: cc,
              title: data.title,
              userImg: data.imageSeller,
              sellerName: data.nameSeller,
              sellerId: data.sellerId,
              videoLink: null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SellerAllServicePage(
                            sellerId: data.sellerId,
                            sellerName: data.nameSeller,
                          )),
                );
              },
            ),

            //package price
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                  border: Border.all(color: cc.borderColor),
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Paket Kami',
                      style: mainFont.copyWith(
                          color: cc.greyFour,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      moneyChanger(double.parse(data.price)),
                      style: mainFont.copyWith(
                          color: cc.primaryColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),

            //checklist
            const SizedBox(
              height: 30,
            ),

            for (int i = 0; i < data.includedService.length; i++)
              ServiceHelper().checkListCommon(
                  data.includedService[i]['include_service_title'])
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: cc.borderColor),
              top: BorderSide(width: 1, color: cc.borderColor),
            ),
          ),
          child: Row(children: [
            //orders completed ========>
            Expanded(
              child: Row(
                children: [
                  Text(
                    data.completeOrder.toString(),
                    style: mainFont.copyWith(
                        color: cc.successColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Pesanan Selesai',
                    maxLines: 1,
                    style: mainFont.copyWith(
                        color: cc.greyFour,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            //vertical border
            Container(
              height: 28,
              width: 1,
              margin: const EdgeInsets.only(left: 10, right: 15),
              color: cc.borderColor,
            ),
            //Sellers ratings ========>
            Row(
              children: [
                Text(
                  data.reviewsForMobile.isEmpty
                      ? '0.0'
                      : getRating(data.reviewsForMobile),
                  style: mainFont.copyWith(
                      color: cc.primaryColor,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Rating Penjual',
                  maxLines: 1,
                  style: mainFont.copyWith(
                      color: cc.greyFour,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}

class ServiceTitleAndUser extends StatelessWidget {
  const ServiceTitleAndUser(
      {Key? key,
      required this.cc,
      required this.title,
      this.userImg,
      required this.sellerName,
      required this.videoLink,
      required this.sellerId,
      required this.onTap})
      : super(key: key);
  final ConstantColors cc;
  final String title;
  final userImg;
  final String sellerName;
  final videoLink;
  final sellerId;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//Watch video button ===========>
        videoLink != null
            ? ElevatedButton(
                onPressed: () {
                  // ServiceHelper().watchVideoPopup(context, videoLink);

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: ((context) => WatchVideoPage(
                  //               videoUrl: videoLink,
                  //             ))));
                },
                child: const Text('Watch video'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: cc.successColor
                ))
            : Container(),

        const SizedBox(
          height: 7,
        ),
        Text(
          title,
          style: mainFont.copyWith(
            color: cc.greyFour,
            fontSize: 19,
            height: 1.4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //profile image and name
        InkWell(
          onTap: () {
            onTap.call();
          },
          child: Row(
            children: [
              userImg != placeHolderUrl
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: userImg,
                        placeholder: (context, url) {
                          return Image.asset('assets/images/placeholder.png');
                        },
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/avatar.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(
                sellerName,
                style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
