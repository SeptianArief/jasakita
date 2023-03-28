import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Steps extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int totalStep;
  final int currenctStep;
  final String serviceName;
  const Steps(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.totalStep,
      required this.currenctStep,
      required this.serviceName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Column(
      children: [
        Row(
          children: [
            CircularStepProgressIndicator(
              totalSteps: totalStep,
              currentStep: currenctStep,
              stepSize: 4,
              selectedColor: cc.primaryColor,
              unselectedColor: Colors.grey[200],
              padding: 0,
              width: 70,
              height: 70,
              selectedStepSize: 4,
              roundedCap: (_, __) => true,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currenctStep/',
                      style: mainFont.copyWith(
                          color: cc.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$totalStep',
                      style: mainFont.copyWith(
                          color: cc.greyParagraph,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHelper().titleCommon(title),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  subtitle,
                  style: mainFont.copyWith(
                    color: cc.greyParagraph,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 17,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) {
                  return Image.asset('assets/images/placeholder.png');
                },
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Flexible(
              child: Text(
                serviceName,
                style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 18,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        CommonHelper().dividerCommon(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
