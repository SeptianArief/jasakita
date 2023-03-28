import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/vm/order_vm.dart';
import 'package:qixer/app/order/widgets/booking_helper.dart';
import 'package:qixer/app/order/widgets/order_detail_panel.dart';
import 'package:qixer/app/order/widgets/steps.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';

class BookConfirmationPage extends StatefulWidget {
  final OrderVM model;
  const BookConfirmationPage({Key? key, required this.model}) : super(key: key);

  @override
  _BookConfirmationPageState createState() => _BookConfirmationPageState();
}

class _BookConfirmationPageState extends State<BookConfirmationPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isPanelOpened = false;

  @override
  Widget build(BuildContext context) {
    PanelController pc = PanelController();

    ConstantColors cc = ConstantColors();
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: ViewModelBuilder<OrderVM>.nonReactive(
          viewModelBuilder: () {
            return widget.model;
          },
          onViewModelReady: (model) {},
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: CommonHelper().appbarForBookingPages('Details', context),
              body: SlidingUpPanel(
                controller: pc,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 17,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
                minHeight: 200,
                panel: OrderDetailsPanel(
                  model: model,
                  panelController: pc,
                ),
                onPanelOpened: () {
                  setState(() {
                    model.panelChanged(true);
                  });
                },
                onPanelClosed: () {
                  setState(() {
                    model.panelChanged(false);
                  });
                },
                body: SingleChildScrollView(
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
                                  currenctStep: 5,
                                  imageUrl: state.data.imageUrl,
                                  serviceName: state.data.title,
                                  title: model.dataTitleSubtitle[4][0],
                                  subtitle: model.dataTitleSubtitle[4][1],
                                  totalStep: 5,
                                );
                              }
                              return Container();
                            }),

                        CommonHelper().titleCommon('Detil Pesanan'),

                        const SizedBox(
                          height: 17,
                        ),

                        //Date Location Time ========>
                        Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: cc.borderColor),
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 18),
                            child: Column(
                              children: [
                                BookingHelper().bdetailsContainer(
                                    'assets/svg/location.svg',
                                    'Location',
                                    '${model.selectedArea!.area}, ${model.selectedCity!.serviceCity}'),

                                //divider
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 18, bottom: 18),
                                  child: CommonHelper().dividerCommon(),
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: BookingHelper().bdetailsContainer(
                                          'assets/svg/calendar.svg',
                                          'Tanggal',
                                          "${model.selectedWeekday}, ${model.monthAndDate}"),
                                    ),
                                    const SizedBox(
                                      width: 13,
                                    ),
                                    BlocBuilder<OrderCubit, OrderState>(
                                        bloc: model.scheduleCubit,
                                        builder: (context, state) {
                                          return Expanded(
                                            child: BookingHelper()
                                                .bdetailsContainer(
                                                    'assets/svg/clock.svg',
                                                    'Waktu',
                                                    state is ScheduleLoaded
                                                        ? state.data[model
                                                            .selectedShedule]
                                                        : ''),
                                          );
                                        })
                                  ],
                                ),
                              ],
                            )),

                        const SizedBox(
                          height: 30,
                        ),

                        BookingHelper().bRow('assets/svg/user.svg', 'Nama',
                            model.userNameController.text),
                        BookingHelper().bRow('assets/svg/email.svg', 'Email',
                            model.emailController.text),
                        BookingHelper().bRow('assets/svg/phone.svg',
                            'Nomor Handphone', model.phoneController.text),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BookingHelper().bRow('assets/svg/location.svg',
                                'Kode Pos', model.postCodeController.text),
                            BookingHelper().bRow('assets/svg/location.svg',
                                'Alamat', model.addressController.text),
                          ],
                        ),

                        const SizedBox(
                          height: 17,
                        ),

                        Text(
                          'Catatan',
                          style: mainFont.copyWith(
                            color: cc.greyFour,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        CommonHelper().paragraphCommon(
                            model.notesController.text.isEmpty
                                ? '-'
                                : model.notesController.text,
                            TextAlign.left),

                        const SizedBox(
                          height: 335,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
