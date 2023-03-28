import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/languages/app_string_service.dart';
import 'package:qixer/shared/widget_helper.dart';

class CommonHelper {
  ConstantColors cc = ConstantColors();
  //common appbar
  appbarCommon(String title, BuildContext context, VoidCallback pressed) {
    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: cc.greyPrimary),
      title: Text(
        (title),
        style: mainFont.copyWith(
            color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: pressed,
        child: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
      ),
    );
  }

  appbarForBookingPages(String title, BuildContext context,
      {bool isPersonalizatioPage = false, VoidCallback? extraFunction}) {
    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: cc.greyPrimary),
      title: Text(
        title,
        style: mainFont.copyWith(
            color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          if (isPersonalizatioPage != true) {
            // BookStepsService().decreaseStep(context);
          } else {
            //if its personalization page then decrease step to 1
            // Provider.of<BookStepsService>(context, listen: false)
            //     .setStepsToDefault();
          }
          Navigator.pop(context);
          if (extraFunction != null) {
            extraFunction.call();
          }
        },
        child: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
      ),
    );
  }

  //common orange button =======>
  buttonOrange(String title, VoidCallback pressed,
      {isloading = false, bgColor, double paddingVerticle = 18}) {
    return InkWell(
      onTap: pressed,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: paddingVerticle),
          decoration: BoxDecoration(
              color: bgColor ?? cc.primaryColor,
              borderRadius: BorderRadius.circular(8)),
          child: isloading == false
              ? Text(
                  title,
                  style: mainFont.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                )
              : showLoading(Colors.white)),
    );
  }

  borderButtonOrange(String title, VoidCallback pressed,
      {bgColor, double paddingVerticle = 17}) {
    return InkWell(
      onTap: pressed,
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: paddingVerticle),
          decoration: BoxDecoration(
              border: Border.all(color: bgColor ?? cc.primaryColor),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            title,
            style: mainFont.copyWith(
              color: bgColor ?? cc.primaryColor,
              fontSize: 14,
            ),
          )),
    );
  }

  labelCommon(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: mainFont.copyWith(
          color: cc.greyThree,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  paragraphCommon(String title, TextAlign textAlign,
      {double fontsize = 14, color}) {
    return Text(
      title,
      textAlign: textAlign,
      style: mainFont.copyWith(
        color: color ?? cc.greyParagraph,
        height: 1.4,
        fontSize: fontsize,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  titleCommon(String title, {double fontsize = 18, color, lineheight = 1.3}) {
    return Text(
      title,
      style: mainFont.copyWith(
          color: color ?? cc.greyPrimary,
          fontSize: fontsize,
          height: lineheight,
          fontWeight: FontWeight.bold),
    );
  }

  dividerCommon() {
    return Divider(
      thickness: 1,
      height: 2,
      color: cc.borderColor,
    );
  }

  checkCircle() {
    return Container(
      padding: const EdgeInsets.all(3),
      child: const Icon(
        Icons.check,
        size: 13,
        color: Colors.white,
      ),
      decoration: BoxDecoration(shape: BoxShape.circle, color: cc.primaryColor),
    );
  }

  profileImage(String imageLink, double height, double width) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(imageLink))),
    );
  }

  //no order found
  nothingfound(BuildContext context, String title, {double? customSize}) {
    return Container(
        height: customSize ?? MediaQuery.of(context).size.height - 120,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 26,
              color: cc.greyFour,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              title,
              style: mainFont.copyWith(color: cc.greyFour),
            ),
          ],
        ));
  }
}
