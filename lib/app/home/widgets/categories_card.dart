import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qixer/app/home/models/categories_model.dart';
import 'package:qixer/app/home/pages/service_by_categories.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class CategoriesCard extends StatelessWidget {
  final Categories data;
  final double marginRight;
  const CategoriesCard({Key? key, required this.data, this.marginRight = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return FractionallySizedBox(
      widthFactor: 0.31,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => ServicebyCategoryPage(
                categoryName: data.name,
                categoryId: data.id.toString(),
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          margin: EdgeInsets.only(
            right: marginRight,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
              border: Border.all(color: cc.primaryColor, width: 0.5),
              borderRadius: BorderRadius.circular(9)),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: data.mobileIcon ?? placeHolderUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.fitHeight,
                  )),
              const SizedBox(
                height: 7,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  data.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: mainFont.copyWith(
                    color: cc.greyFour,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
