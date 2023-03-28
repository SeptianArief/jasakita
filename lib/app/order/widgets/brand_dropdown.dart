import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class BrandDropdownCustom extends StatelessWidget {
  final List<dynamic> dataBrand;
  final String? selectedBrand;
  final Function(String) onChanged;
  const BrandDropdownCustom(
      {Key? key,
      required this.dataBrand,
      required this.selectedBrand,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: cc.greyFive),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                // menuMaxHeight: 200,
                isExpanded: true,
                value: selectedBrand,
                icon:
                    Icon(Icons.keyboard_arrow_down_rounded, color: cc.greyFour),
                iconSize: 26,
                elevation: 17,
                style: mainFont.copyWith(color: cc.greyFour),
                onChanged: (newValue) {
                  onChanged(newValue!);
                },
                hint: Text('Pilih Brand'),
                items: List.generate(dataBrand.length, (index) {
                  return DropdownMenuItem(
                    value: dataBrand[index].toString(),
                    child: Text(
                      dataBrand[index].toString(),
                      style: mainFont.copyWith(
                          color: cc.greyPrimary.withOpacity(.8)),
                    ),
                  );
                })),
          ),
        ),
      ],
    );
  }
}
