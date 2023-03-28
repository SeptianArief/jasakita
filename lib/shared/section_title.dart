import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.pressed,
    this.hasSeeAllBtn = true,
  }) : super(key: key);

  final String title;
  final VoidCallback pressed;
  final bool hasSeeAllBtn;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Row(
      children: [
        Text(
          title,
          style: mainFont.copyWith(
            color: cc.greyFour,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasSeeAllBtn)
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: pressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat Semua',
                    style: mainFont.copyWith(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
