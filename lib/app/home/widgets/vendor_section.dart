import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_cubit.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_state.dart';
import 'package:qixer/app/home/models/vendor_model.dart';
import 'package:qixer/app/home/pages/vendor_detail_page.dart';
import 'package:qixer/app/home/pages/vendor_list_page.dart';
import 'package:qixer/app/home/services/vendor_service.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/section_title.dart';
import 'package:qixer/shared/widget_helper.dart';

class VendorSection extends StatelessWidget {
  final HomeVM model;
  const VendorSection({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    //List vendor
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle(
              title: 'Vendor Jasa Kita',
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VendorListPage(
                            cubit: model.vendorCubit,
                          )),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<VendorCubit, VendorState>(
            bloc: model.vendorCubit,
            builder: (context, state) {
              if (state is VendorLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(state.data.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SellerAllServicePage(
                                      sellerId: state.data[index].id.toString(),
                                      sellerName: state.data[index].name)));
                        },
                        child: Card(
                          margin: EdgeInsets.only(
                              right: index == state.data.length - 1 ? 20 : 0,
                              bottom: 10,
                              left: index == 0 ? 20 : 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: 120,
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black12,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              state.data[index].image))),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  state.data[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: mainFont.copyWith(
                                      fontSize: 12, color: cc.greyFour),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: List.generate(
                                          state.data[index].rating, (index) {
                                        return const Icon(
                                          Icons.star,
                                          size: 10,
                                          color: Colors.amber,
                                        );
                                      }),
                                    ),
                                    Row(
                                      children: List.generate(
                                          5 - state.data[index].rating,
                                          (index) {
                                        return const Icon(
                                          Icons.star,
                                          size: 10,
                                          color: Colors.grey,
                                        );
                                      }),
                                    ),
                                    Text(
                                      ' (${state.data[index].sellerRating.toStringAsFixed(1)})',
                                      style: mainFont.copyWith(
                                          fontSize: 9, color: Colors.black54),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: cc.primaryColor),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${state.data[index].completeOrder} Pesanan Selesai',
                                    style: mainFont.copyWith(
                                        color: Colors.white, fontSize: 9),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
