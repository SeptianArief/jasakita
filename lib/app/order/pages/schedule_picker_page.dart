import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/pages/location_picker_page.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/order/widgets/steps.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class SchedulePickerPage extends StatefulWidget {
  final OrderVM model;
  const SchedulePickerPage({Key? key, required this.model}) : super(key: key);

  @override
  State<SchedulePickerPage> createState() => _SchedulePickerPageState();
}

class _SchedulePickerPageState extends State<SchedulePickerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<OrderVM>.nonReactive(viewModelBuilder: () {
      return widget.model;
    }, onViewModelReady: (model) {
      model.onScheduleReload(context);
    }, builder: (context, model, child) {
      return BlocBuilder<ServiceCubit, ServiceState>(
          bloc: widget.model.serviceCubit,
          builder: (context, state) {
            if (state is ServiceBookingLoaded) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: CommonHelper().appbarForBookingPages(
                        'Jadwal', context, extraFunction: () {
                      //set coupon value to default again
                      // Provider.of<CouponService>(context, listen: false).setCouponDefault();
                    }),
                    body: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Circular Progress bar
                                    Steps(
                                      currenctStep: 2,
                                      imageUrl: state.data.imageUrl,
                                      subtitle:
                                          widget.model.dataTitleSubtitle[1][1],
                                      title: widget.model.dataTitleSubtitle[1]
                                          [0],
                                      serviceName: state.data.title,
                                      totalStep: 5,
                                    ),

                                    DatePicker(
                                      DateTime.now(),
                                      initialSelectedDate: DateTime.now(),
                                      daysCount: 7,
                                      selectionColor: cc.primaryColor,
                                      selectedTextColor: Colors.white,
                                      locale: 'id_ID',
                                      onDateChange: (value) {
                                        model.onChangeDate(value);
                                        model.onScheduleReload(context);
                                      },
                                    ),

                                    // Time =============================>
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    CommonHelper()
                                        .titleCommon('${'Waktu Tersedia'}:'),

                                    const SizedBox(
                                      height: 17,
                                    ),

                                    BlocBuilder<OrderCubit, OrderState>(
                                      bloc: model.scheduleCubit,
                                      builder: (context, state) {
                                        if (state is OrderLoading) {
                                          return showLoading(cc.primaryColor);
                                        } else if (state is ScheduleLoaded) {
                                          return state.data.isNotEmpty
                                              ? GridView.builder(
                                                  clipBehavior: Clip.none,
                                                  gridDelegate:
                                                      FlutterzillaFixedGridView(
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 19,
                                                          crossAxisSpacing: 19,
                                                          height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width <
                                                                  fourinchScreenWidth
                                                              ? 75
                                                              : 60),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  itemCount: state.data.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        setState(() {
                                                          model
                                                              .onChangeScheduleIndex(
                                                                  index);
                                                        });
                                                      },
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: model.selectedShedule ==
                                                                            index
                                                                        ? cc
                                                                            .primaryColor
                                                                        : cc
                                                                            .borderColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        13,
                                                                    vertical:
                                                                        15),
                                                            child: Text(
                                                              state.data[index],
                                                              style: mainFont
                                                                  .copyWith(
                                                                color:
                                                                    cc.greyFour,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          model.selectedShedule ==
                                                                  index
                                                              ? Positioned(
                                                                  right: -7,
                                                                  top: -7,
                                                                  child: CommonHelper()
                                                                      .checkCircle())
                                                              : Container()
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Text(
                                                  'Tidak ada jadwal tersedia',
                                                  style: mainFont.copyWith(
                                                      color: cc.primaryColor),
                                                );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                )),
                          ),
                        ),

                        //  bottom container
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, top: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 8,
                                blurRadius: 17,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // CommonHelper().titleCommon('Scheduling for:'),
                                // const SizedBox(
                                //   height: 15,
                                // ),
                                // BookingHelper().rowLeftRight(
                                //     'assets/svg/calendar.svg',
                                //     'Date',
                                //     'Friday, 18 March 2022'),
                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // BookingHelper().rowLeftRight(
                                //     'assets/svg/clock.svg',
                                //     'Time',
                                //     '02:00 PM -03:00 PM'),
                                // const SizedBox(
                                //   height: 23,
                                // ),
                                CommonHelper().buttonOrange('Selanjutnya', () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BookingLocationPage(
                                                model: model,
                                              )));
                                }),
                                const SizedBox(
                                  height: 30,
                                ),
                              ]),
                        )
                      ],
                    )),
              );
            } else {
              return Container();
            }
          });
    });
  }
}
