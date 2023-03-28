import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/pages/confirmation_page.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/app/order/widgets/steps.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';
import 'package:stacked/stacked.dart';

class DeliveryAddressPage extends StatefulWidget {
  final OrderVM model;
  const DeliveryAddressPage({Key? key, required this.model}) : super(key: key);

  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<OrderVM>.nonReactive(
        viewModelBuilder: () {
          return widget.model;
        },
        onViewModelReady: (model) {},
        builder: (context, model, child) {
          return Listener(
            onPointerDown: (_) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: WillPopScope(
              onWillPop: () {
                return Future.value(true);
              },
              child: Scaffold(
                // resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                appBar: CommonHelper().appbarForBookingPages('Alamat', context),
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
                                BlocBuilder<ServiceCubit, ServiceState>(
                                    bloc: model.serviceCubit,
                                    builder: (context, state) {
                                      if (state is ServiceBookingLoaded) {
                                        return Steps(
                                          currenctStep: 4,
                                          imageUrl: state.data.imageUrl,
                                          serviceName: state.data.title,
                                          title: model.dataTitleSubtitle[3][0],
                                          subtitle: model.dataTitleSubtitle[3]
                                              [1],
                                          totalStep: 5,
                                        );
                                      }
                                      return Container();
                                    }),

                                CommonHelper().titleCommon('Informasi Pesanan'),

                                const SizedBox(
                                  height: 22,
                                ),

                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // name ============>
                                      CommonHelper().labelCommon('Nama'),

                                      CustomInput(
                                        controller: model.userNameController,
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Silahkan masukkan nama Anda';
                                          }
                                          return null;
                                        },
                                        hintText: 'Masukkan nama Anda',
                                        icon: 'assets/icons/user.png',
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      //Email ============>
                                      CommonHelper().labelCommon('Email'),

                                      CustomInput(
                                        controller: model.emailController,
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mohon Masukkan Email Anda';
                                          }
                                          return null;
                                        },
                                        hintText: "Masukkan Email Anda",
                                        icon: 'assets/icons/email-grey.png',
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),

                                      //Phone number field
                                      CommonHelper()
                                          .labelCommon('Nomor Handphone'),
                                      CustomInput(
                                        controller: model.phoneController,
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Mohon Masukkan Nomor Handphone Anda';
                                          }
                                          return null;
                                        },
                                        hintText:
                                            "Masukkan Nomor Handphone Anda",
                                        textInputAction: TextInputAction.next,
                                      ),

                                      SizedBox(height: 20),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonHelper()
                                              .labelCommon('Kode Pos'),

                                          CustomInput(
                                            controller:
                                                model.postCodeController,
                                            validation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Mohon Masukkan Kode Pos';
                                              }
                                              return null;
                                            },
                                            hintText: 'Masukkan Kode Pos',
                                            icon: 'assets/icons/location.png',
                                            textInputAction:
                                                TextInputAction.next,
                                          ),

                                          //Address ============>

                                          const SizedBox(
                                            height: 20,
                                          ),

                                          CommonHelper()
                                              .labelCommon('Alamat Anda'),

                                          CustomInput(
                                            controller: model.addressController,
                                            validation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Mohon Masukkan Alamat Anda';
                                              }
                                              return null;
                                            },
                                            hintText: 'Alamat Anda',
                                            icon: 'assets/icons/location.png',
                                            textInputAction:
                                                TextInputAction.next,
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),

                    ///Next button
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 20, right: 20, bottom: 20),
                      decoration: BookingHelper().bottomSheetDecoration(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHelper().buttonOrange('Selanjutnya', () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BookConfirmationPage(
                                              model: model,
                                            )));
                              }
                            }),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
