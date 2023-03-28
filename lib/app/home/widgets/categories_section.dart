import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_cubit.dart';
import 'package:qixer/app/home/cubits/categories_cubit/categories_state.dart';
import 'package:qixer/app/home/pages/category_all_page.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/app/home/widgets/categories_card.dart';
import 'package:qixer/shared/section_title.dart';

class CategoriesSection extends StatelessWidget {
  final HomeVM model;
  const CategoriesSection({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //see all ============>
          const SizedBox(
            height: 25,
          ),

          SectionTitle(
            title: 'Kategori Jasa',
            pressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AllCategoriesPage(
                    model: model,
                  ),
                ),
              );
            },
          ),

          const SizedBox(
            height: 18,
          ),

          //Categories =============>
          BlocBuilder<CategoriesCubit, CategoriesState>(
              bloc: model.categoriesCubit,
              builder: (context, state) {
                if (state is CategoriesLoaded) {
                  return Container(
                    margin: const EdgeInsets.only(top: 5),
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
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}
