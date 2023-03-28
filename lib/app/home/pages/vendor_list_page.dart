import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_cubit.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_state.dart';
import 'package:qixer/app/home/models/vendor_model.dart';
import 'package:qixer/app/home/pages/vendor_detail_page.dart';
import 'package:qixer/app/home/services/vendor_service.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/widget_helper.dart';

class VendorListPage extends StatefulWidget {
  final VendorCubit cubit;
  const VendorListPage({Key? key, required this.cubit}) : super(key: key);

  @override
  State<VendorListPage> createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> {
  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CommonHelper().appbarCommon('Vendor Jasa Kita', context, () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<VendorCubit, VendorState>(
            bloc: widget.cubit,
            builder: (context, state) {
              if (state is VendorLoaded) {
                return Expanded(
                    child: Container(
                        color: Colors.white,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: [
                            Center(
                              child: Wrap(
                                runSpacing: 10,
                                spacing:
                                    MediaQuery.of(context).size.width * 0.01,
                                children:
                                    List.generate(state.data.length, (index) {
                                  return FractionallySizedBox(
                                      widthFactor: 0.315,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      SellerAllServicePage(
                                                          sellerId: state
                                                              .data[index].id
                                                              .toString(),
                                                          sellerName: state
                                                              .data[index]
                                                              .name)));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                              state.data[index]
                                                                  .image))),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  state.data[index].name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: mainFont.copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: cc.greyFour),
                                                ),
                                                Text(
                                                  state.data[index].cityName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: mainFont.copyWith(
                                                      fontSize: 10,
                                                      color: cc.greyFour),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: List.generate(
                                                          state.data[index]
                                                              .rating, (index) {
                                                        return const Icon(
                                                          Icons.star,
                                                          size: 10,
                                                          color: Colors.amber,
                                                        );
                                                      }),
                                                    ),
                                                    Row(
                                                      children: List.generate(
                                                          5 -
                                                              state.data[index]
                                                                  .rating,
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
                                                          fontSize: 9,
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: cc.primaryColor),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '${state.data[index].completeOrder} Pesanan Selesai',
                                                    style: mainFont.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 9),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                                }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        )));
              } else if (state is VendorLoading) {
                return Center(
                  child: showLoading(cc.primaryColor),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    ));
  }
}
