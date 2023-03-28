import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_cubit.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_state.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/app/home/widgets/categories_card.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';

class AllCategoriesPage extends StatelessWidget {
  final HomeVM model;
  const AllCategoriesPage({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Semua Kategori', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
            bloc: model.categoriesCubit,
            builder: (context, state) {
              if (state is CategoriesLoaded) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Wrap(
                        runSpacing: 20,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < state.data.length; i++)
                            CategoriesCard(
                              data: state.data[i],
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
