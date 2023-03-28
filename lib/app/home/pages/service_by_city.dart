import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/auth/widgets/area_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/pages/service_by_city_detail.dart';
import 'package:qixer/app/home/vm/service_by_categories_vm.dart';
import 'package:qixer/app/home/widgets/service_card.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/section_title.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class ServiceByCityPage extends StatefulWidget {
  final String name;
  final ServiceCubit? currenctCubit;
  const ServiceByCityPage({Key? key, required this.name, this.currenctCubit})
      : super(key: key);

  @override
  State<ServiceByCityPage> createState() => _ServiceByCityPageState();
}

class _ServiceByCityPageState extends State<ServiceByCityPage> {
  ServiceCubit serviceCubit = ServiceCubit();

  @override
  void initState() {
    if (widget.currenctCubit != null) {
      serviceCubit = widget.currenctCubit!;
    } else {
      serviceCubit.fetchServiceGrouping(context, city: widget.name);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon(widget.name, context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ServiceCubit, ServiceState>(
                bloc: serviceCubit,
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
                  } else if (state is ServiceLoading) {
                    return Center(
                      child: showLoading(cc.primaryColor),
                    );
                  }

                  return Container();
                }),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
