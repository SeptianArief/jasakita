import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/pages/schedule_picker_page.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/app/order/widgets/brand_dropdown.dart';
import 'package:qixer/app/order/widgets/extras.dart';
import 'package:qixer/app/order/widgets/included.dart';
import 'package:qixer/app/order/widgets/steps.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class ServicePersonalizationPage extends StatefulWidget {
  final String serviceId;
  final List<dynamic> brands;
  const ServicePersonalizationPage(
      {Key? key, required this.serviceId, required this.brands})
      : super(key: key);

  @override
  _ServicePersonalizationPageState createState() =>
      _ServicePersonalizationPageState();
}

class _ServicePersonalizationPageState
    extends State<ServicePersonalizationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<OrderVM>.reactive(viewModelBuilder: () {
      return OrderVM();
    }, onViewModelReady: (model) {
      model.onLocationInit(context);
      model.onInit(context, id: widget.serviceId);
    }, builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () {
          // BookStepsService().decreaseStep(context);
          return Future.value(true);
        },
        child: BlocBuilder<ServiceCubit, ServiceState>(
            bloc: model.serviceCubit,
            builder: (context, state) {
              if (state is ServiceLoading) {
                return Scaffold(
                  body: Center(
                    child: showLoading(cc.primaryColor),
                  ),
                );
              } else if (state is ServiceBookingLoaded) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: CommonHelper().appbarForBookingPages(
                      'Personalisasi', context,
                      isPersonalizatioPage: true, extraFunction: () {}),
                  body: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Steps(
                                currenctStep: model.currentIndex,
                                imageUrl: state.data.imageUrl,
                                serviceName: state.data.title,
                                totalStep: model.totalIndex,
                                title: model.dataTitleSubtitle[0][0],
                                subtitle: model.dataTitleSubtitle[0][1],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonHelper().titleCommon('Termasuk:'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Included(
                                    data: state.data.serviceIncluded,
                                    model: model,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),

                              state.data.serviceAdditional.isNotEmpty
                                  ? Extras(
                                      model: model,
                                      additionalServices:
                                          state.data.serviceAdditional,
                                      serviceBenefits:
                                          state.data.serviceBenefits,
                                    )
                                  : Container(),

                              // button ==================>
                              const SizedBox(
                                height: 10,
                              ),

                              Column(
                                children: [
                                  widget.brands.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pilih Merk',
                                              style: mainFont.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            BrandDropdownCustom(
                                              dataBrand: widget.brands,
                                              selectedBrand:
                                                  model.selectedBrand,
                                              onChanged: (value) {
                                                model.setBrands(value);
                                              },
                                            )
                                          ],
                                        )
                                      : Container(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 27,
                                      ),
                                      Text(
                                        'Catatan Pesanan',
                                        style: mainFont.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomInput(
                                        controller: model.notesController,
                                        validation: (value) {
                                          return null;
                                        },
                                        hintText: "Masukkan catatan pesanan",
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 50,
                              ),
                              // CommonHelper().buttonOrange("Next", () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute<void>(
                              //       builder: (BuildContext context) =>
                              //           const ServiceSchedulePage(),
                              //     ),
                              //   );
                              // }),

                              const SizedBox(
                                height: 147,
                              ),
                            ],
                          ))),
                  bottomSheet: Container(
                    height: 157,
                    padding:
                        const EdgeInsets.only(left: 20, top: 30, right: 20),
                    decoration: BookingHelper().bottomSheetDecoration(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BookingHelper().detailsPanelRow(
                              'Total', 0, moneyChanger(model.getTotalPrice())),
                          const SizedBox(
                            height: 12,
                          ),
                          CommonHelper().buttonOrange('Selanjutnya', () {
                            // if (personalizationProvider.isloading == false) {
                            //   if (personalizationProvider.isOnline == 1) {
                            //     //if it is an online service no need to show service schedule and choose location page

                            //     BookStepsService().onNext(context);
                            //   } else {
                            //     //increase page steps by one
                            //     BookStepsService().onNext(context);
                            //     //fetch shedule
                            //     Provider.of<SheduleService>(context, listen: false)
                            //         .fetchShedule(provider.sellerId,
                            //             firstThreeLetter(DateTime.now()));

                            //     //go to shedule page
                            //     Navigator.push(
                            //         context,
                            //         PageTransition(
                            //             type: PageTransitionType.rightToLeft,
                            //             child: const ServiceSchedulePage()));
                            //   }
                            // }

                            if (widget.brands.isNotEmpty) {
                              if (model.selectedBrand != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SchedulePickerPage(
                                              model: model,
                                            )));
                              } else {
                                FormHelper.showSnackbar(context,
                                    data: 'Mohon memilih merk',
                                    colors: Colors.orange);
                              }
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SchedulePickerPage(
                                            model: model,
                                          )));
                            }
                          }),
                          const SizedBox(
                            height: 30,
                          ),
                        ]),
                  ),
                );
              } else {
                return Container();
              }
            }),
      );
    });
  }
}
