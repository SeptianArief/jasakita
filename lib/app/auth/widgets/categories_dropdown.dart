import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_cubit.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_state.dart';
import 'package:qixer/app/home/models/categories_model.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/cubits/area_master/area_cubit.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/area_master/area_state.dart';
import 'package:qixer/shared/cubits/city_master/city_cubit.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/cubits/city_master/city_state.dart';
import 'package:qixer/shared/widget_helper.dart';

class CategoriesDropdown extends StatelessWidget {
  final int? selectedCity;
  final Function(Categories) onChanged;
  final bool showAll;
  final CategoriesCubit cubit;
  const CategoriesDropdown(
      {Key? key,
      this.selectedCity,
      this.showAll = true,
      required this.cubit,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return BlocBuilder<CategoriesCubit, CategoriesState>(
        bloc: cubit,
        builder: ((context, state) {
          if (state is CategoriesLoaded) {
            List<Categories> data = [];
            data.add(Categories(
                icon: '', id: 99, name: 'semua Kategori', mobileIcon: ''));

            data.addAll(state.data);

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: cc.greyFive),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                    // menuMaxHeight: 200,
                    isExpanded: true,
                    value: selectedCity,
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: cc.greyFour),
                    iconSize: 26,
                    elevation: 17,
                    style: mainFont.copyWith(color: cc.greyFour),
                    onChanged: (newValue) {
                      late Categories newCity;

                      data.forEach((element) {
                        if (element.id == newValue) {
                          newCity = element;
                        }
                      });

                      onChanged(newCity);
                    },
                    hint: const Text('Pilih Kota'),
                    items: List.generate(data.length, (index) {
                      return DropdownMenuItem(
                        value: data[index].id,
                        child: Text(
                          data[index].name.toString(),
                          style: mainFont.copyWith(
                              color: cc.greyPrimary.withOpacity(.8)),
                        ),
                      );
                    })),
              ),
            );
          } else if (state is AreaLoading) {
            return showLoading(cc.primaryColor);
          } else {
            return Container();
          }
        }));
  }
}
