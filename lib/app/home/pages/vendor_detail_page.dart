import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_cubit.dart';
import 'package:qixer/app/home/cubits/vendor_cubit/vendor_state.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/services/service_service.dart';
import 'package:qixer/app/order/pages/order_page.dart';
import 'package:qixer/app/service/pages/service_detail_page.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/cubits/city_master/city_cubit.dart';
import 'package:qixer/shared/cubits/city_master/city_state.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/widget_helper.dart';

class SellerAllServicePage extends StatefulWidget {
  const SellerAllServicePage(
      {Key? key, this.sellerName = '', required this.sellerId})
      : super(key: key);

  final String sellerName;
  final String sellerId;

  @override
  State<SellerAllServicePage> createState() => _ServicebyCategoryPageState();
}

class _ServicebyCategoryPageState extends State<SellerAllServicePage> {
  VendorCubit vendorCubit = VendorCubit();

  @override
  void initState() {
    vendorCubit.fetchVendorDetail(context, id: widget.sellerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Detil Vendor', context, () {
          Navigator.pop(context);
        }),
        body: BlocBuilder<VendorCubit, VendorState>(
            bloc: vendorCubit,
            builder: (context, state) {
              if (state is VendorDetailLoaded) {
                getRatingFromMaster(int id) {
                  int totalCount = 0;
                  int totalData = 0;

                  state.data.dataReview.forEach((element) {
                    if (element['service_id'].toString() == id.toString()) {
                      print('ada yang masuk');
                      totalCount = totalCount + int.parse(element['rating']);
                      totalData = totalData + 1;
                    }
                  });

                  return totalData == 0 ? 0.0 : totalCount / totalData;
                }

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                                image: DecorationImage(
                                    image:
                                        NetworkImage(state.data.preview.image),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.data.preview.name,
                                style: mainFont.copyWith(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        Icons.star,
                                        size: 12,
                                        color: (index + 1) <=
                                                state.data.serviceRating
                                            ? Colors.amber
                                            : Colors.grey,
                                      );
                                    }),
                                  ),
                                  Text(
                                    ' (${state.data.serviceRating})',
                                    style: mainFont.copyWith(
                                        fontSize: 11, color: Colors.black54),
                                  )
                                ],
                              ),
                              BlocBuilder<CityCubit, CityState>(
                                  bloc: BlocProvider.of<CityCubit>(context),
                                  builder: (context, stateCity) {
                                    String cityName = '';

                                    if (stateCity is CityLoaded) {
                                      for (var i = 0;
                                          i < stateCity.data.length;
                                          i++) {
                                        if (state.data.preview.serviceCity ==
                                            stateCity.data[i].id.toString()) {
                                          cityName =
                                              stateCity.data[i].serviceCity;
                                        }
                                      }
                                    }

                                    return Text(
                                      cityName,
                                      style: mainFont.copyWith(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    );
                                  }),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: cc.primaryColor),
                                child: Text(
                                  '${state.data.completeOrder} Pesanan Selesai',
                                  style: mainFont.copyWith(
                                      fontSize: 9, color: Colors.white),
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 1,
                      color: Colors.black12,
                    ),
                    Expanded(
                        child: state.data.dataService.isEmpty
                            ? Center(
                                child: Text(
                                  'Data Layanan tidak ditemukan',
                                  style: mainFont.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Layanan Jasa',
                                    style: mainFont.copyWith(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      runSpacing: 20,
                                      children: List.generate(
                                          state.data.dataService.length, (i) {
                                        ServiceModel dataService =
                                            state.data.dataService[i];
                                        return FractionallySizedBox(
                                          widthFactor: 0.49,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ServiceDetailsPage(
                                                            serviceId:
                                                                dataService.id
                                                                    .toString(),
                                                          )));
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute<void>(
                                              //     builder: (BuildContext context) =>
                                              //         const ServiceDetailsPage(),
                                              //   ),
                                              // );
                                              // Provider.of<ServiceDetailsService>(context,
                                              //         listen: false)
                                              //     .fetchServiceDetails(dataService['id']);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                children: [
                                                  AspectRatio(
                                                    aspectRatio: 3 / 2,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.black12,
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: NetworkImage(
                                                                  dataService
                                                                      .image))),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 7),
                                                    color: cc.primaryColor,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                          dataService.areaName,
                                                          style:
                                                              mainFont.copyWith(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white),
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                          child: Text(
                                                            dataService.title,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: mainFont.copyWith(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Harga Mulai',
                                                          style:
                                                              mainFont.copyWith(
                                                                  fontSize: 10),
                                                        ),
                                                        Text(
                                                          moneyChanger(
                                                              double.parse(
                                                                  dataService
                                                                      .price)),
                                                          style:
                                                              mainFont.copyWith(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 20,
                                                              height: 20,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .black12,
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: NetworkImage(state
                                                                          .data
                                                                          .preview
                                                                          .image))),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  widget
                                                                      .sellerName,
                                                                  style: mainFont.copyWith(
                                                                      fontSize:
                                                                          9,
                                                                      color: Colors
                                                                          .black87),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children:
                                                                          List.generate(
                                                                              5,
                                                                              (index) {
                                                                        return Icon(
                                                                          Icons
                                                                              .star,
                                                                          size:
                                                                              9,
                                                                          color: (index + 1) <= getRatingFromMaster(state.data.dataService[i].id).toInt()
                                                                              ? Colors.amber
                                                                              : Colors.grey,
                                                                        );
                                                                      }),
                                                                    ),
                                                                    Text(
                                                                      ' (${getRatingFromMaster(state.data.dataService[i].id).toStringAsFixed(1)})',
                                                                      style: mainFont.copyWith(
                                                                          fontSize:
                                                                              9,
                                                                          color:
                                                                              Colors.black54),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            EasyLoading.show();
                                                            ServiceService.fetchDetailService(
                                                                    context,
                                                                    id: state
                                                                        .data
                                                                        .dataService[
                                                                            i]
                                                                        .id
                                                                        .toString())
                                                                .then((value) {
                                                              EasyLoading
                                                                  .dismiss();
                                                              if (value
                                                                      .status ==
                                                                  RequestStatus
                                                                      .successRequest) {
                                                                ServiceDetail
                                                                    data =
                                                                    value.data;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (_) =>
                                                                            ServicePersonalizationPage(
                                                                              serviceId: data.id.toString(),
                                                                              brands: data.brands,
                                                                            )));
                                                              } else {
                                                                FormHelper.showSnackbar(
                                                                    context,
                                                                    data:
                                                                        'Gagal mengambil data, mohon coba lagi',
                                                                    colors: Colors
                                                                        .orange);
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            alignment: Alignment
                                                                .center,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                color: cc
                                                                    .primaryColor),
                                                            child: Text(
                                                              'Pesan',
                                                              style: mainFont
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ))
                  ],
                );
              } else if (state is VendorLoading) {
                return Center(child: showLoading(cc.primaryColor));
              } else {
                return Container();
              }
            }));
  }
}
