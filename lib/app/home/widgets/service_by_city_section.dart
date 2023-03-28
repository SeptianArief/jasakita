import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/pages/service_by_city.dart';
import 'package:qixer/app/home/pages/service_by_city_detail.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/app/home/widgets/service_card.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/cubits/city_master/city_cubit.dart';
import 'package:qixer/shared/cubits/city_master/city_state.dart';
import 'package:qixer/shared/section_title.dart';

class ServiceByCitySection extends StatelessWidget {
  final HomeVM model;
  const ServiceByCitySection({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Column(children: [
      Container(
        margin: EdgeInsets.only(
          top: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Cari Jasa di Kota Lain',
                style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Temukan Jasakita di kota lain diseluruh indonesia',
                  style: mainFont.copyWith(
                    color: cc.greyPrimary,
                    fontSize: 12,
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<CityCubit, CityState>(
                bloc: model.availableCityCubit,
                builder: (context, state) {
                  if (state is CityLoaded) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(state.data.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ServiceByCityPage(
                                            name: state.data[index].serviceCity,
                                            currenctCubit:
                                                model.getLocationMaster(
                                                            context) ==
                                                        state.data[index]
                                                            .serviceCity
                                                    ? model.serviceByCityCubit
                                                    : null,
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: index == 0 ? 20 : 5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: model.getLocationMaster(context) ==
                                          state.data[index].serviceCity
                                      ? cc.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(color: cc.primaryColor)),
                              child: Text(
                                state.data[index].serviceCity,
                                style: mainFont.copyWith(
                                    fontSize: 12,
                                    color: model.getLocationMaster(context) ==
                                            state.data[index].serviceCity
                                        ? Colors.white
                                        : cc.primaryColor),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }

                  return Container();
                }),
            BlocBuilder<ServiceCubit, ServiceState>(
                bloc: model.serviceByCityCubit,
                builder: (context, state) {
                  if (state is ServiceGroupingLoaded) {
                    return Column(
                      children: List.generate(state.data.length, (index) {
                        return state.data[index].data.isEmpty
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: SectionTitle(
                                      title: state.data[index].name,
                                      pressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                ServiceByCityDetailPage(
                                              data: state.data[index].data,
                                              title: state.data[index].name,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(
                                          state.data[index].data.length,
                                          (index2) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              right: index2 ==
                                                      state.data[index].data
                                                              .length -
                                                          1
                                                  ? 20
                                                  : 0,
                                              left: index2 == 0 ? 20 : 0),
                                          child: ServiceCard(
                                              data: state
                                                  .data[index].data[index2]),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              );
                      }),
                    );
                  }

                  return Container();
                }),
          ],
        ),
      )
    ]);
  }
}
