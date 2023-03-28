import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/pages/vendor_detail_page.dart';
import 'package:qixer/app/service/widgets/service_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class AboutSellerTab extends StatelessWidget {
  final ServiceDetail data;
  const AboutSellerTab({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //profile image, name and completed orders
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => SellerAllServicePage(
                  sellerId: data.sellerId,
                  sellerName: data.nameSeller,
                ),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data.imageSeller != placeHolderUrl
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: data.imageSeller,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.nameSeller,
                    style: mainFont.copyWith(
                        color: cc.greyFour,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Text(
                        'Pesanan Selesai',
                        style: mainFont.copyWith(
                          color: cc.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(${data.completeOrder.toString()})',
                        style: mainFont.copyWith(
                          color: cc.greyParagraph,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: cc.borderColor, width: 1),
              borderRadius: BorderRadius.circular(6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ServiceHelper()
                        .serviceDetails('Dari', data.serviceCityName),
                  ),
                  Expanded(
                      child: ServiceHelper().serviceDetails(
                          'Persentase Pesanan Selesai',
                          '${data.completeRate}%'))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: ServiceHelper().serviceDetails(
                        'Berjualan Sejak', data.memberSince.substring(0, 4)),
                  ),
                  Expanded(
                      child: ServiceHelper().serviceDetails(
                          'Pesanan Selesai', data.completeOrder.toString()))
                ],
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              // Text(
              //   'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less.',
              //   style: mainFont.copyWith(
              //     color: cc.greyParagraph,
              //     fontSize: 14,
              //     height: 1.4,
              //   ),
              // ),
            ],
          ),
        ),
      ]),
    );
  }
}
