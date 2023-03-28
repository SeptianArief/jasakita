import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/widgets/area_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/pages/delivery_page.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/order/widgets/steps.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:stacked/stacked.dart';

class BookingLocationPage extends StatefulWidget {
  final OrderVM model;
  const BookingLocationPage({Key? key, required this.model}) : super(key: key);

  @override
  _BookingLocationPageState createState() => _BookingLocationPageState();
}

class _BookingLocationPageState extends State<BookingLocationPage> {
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
      Future.delayed(Duration(milliseconds: 0), () {
        // model.onLocationInit(context);
      });
    }, builder: (context, model, child) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          appBar: CommonHelper().appbarForBookingPages(
            "Lokasi",
            context,
          ),
          body: BlocBuilder<ServiceCubit, ServiceState>(
              bloc: model.serviceCubit,
              builder: (context, state) {
                if (state is ServiceBookingLoaded) {
                  return SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Circular Progress bar
                            Steps(
                              currenctStep: 3,
                              imageUrl: state.data.imageUrl,
                              serviceName: state.data.title,
                              subtitle: model.dataTitleSubtitle[2][1],
                              title: model.dataTitleSubtitle[2][0],
                              totalStep: 5,
                            ),

                            CommonHelper().titleCommon('Informasi Pesanan'),

                            const SizedBox(
                              height: 20,
                            ),

                            CommonHelper().labelCommon("Pilih Kota"),
                            DropdownCityAll(
                              onChanged: (value) {
                                setState(() {
                                  model.onCityChanged(context, value);
                                });
                              },
                              selectedCity: model.selectedCity?.id,
                              showAll: false,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CommonHelper().labelCommon("Pilih Area"),
                            AreaDropdown(
                              cubit: model.areaCubit,
                              onChanged: (value) {
                                setState(() {
                                  model.onChangeArea(value);
                                });
                              },
                              selectedCity: model.selectedArea?.id,
                              showAll: false,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // AreaDropdown(cubit: cubit, onChanged: (value) {}),

                            //Login button ==================>
                            const SizedBox(
                              height: 27,
                            ),
                            CommonHelper().buttonOrange('Selanjutnya', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DeliveryAddressPage(model: model)));
                            }),

                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        )),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      );
    });
  }
}
