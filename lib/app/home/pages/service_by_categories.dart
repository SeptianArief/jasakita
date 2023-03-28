import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/auth/widgets/area_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/vm/service_by_categories_vm.dart';
import 'package:qixer/app/home/widgets/service_card.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class ServicebyCategoryPage extends StatefulWidget {
  const ServicebyCategoryPage(
      {Key? key, this.categoryName = '', required this.categoryId})
      : super(key: key);

  final String categoryName;
  final categoryId;

  @override
  State<ServicebyCategoryPage> createState() => _ServicebyCategoryPageState();
}

class _ServicebyCategoryPageState extends State<ServicebyCategoryPage> {
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return ViewModelBuilder<ServiceByCategoriesVM>.reactive(
        viewModelBuilder: () {
      return ServiceByCategoriesVM();
    }, onViewModelReady: (model) {
      model.onInit(context, id: widget.categoryId);
    }, builder: (context, model, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon(widget.categoryName, context, () {
          Navigator.pop(context);
        }),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  DropdownCityAll(
                    onChanged: (value) {
                      model.onCityChanged(
                        context,
                        value,
                        id: widget.categoryId,
                      );
                    },
                    selectedCity: model.selectedCity == null
                        ? 99
                        : model.selectedCity!.id,
                    showAll: true,
                  ),
                  model.selectedCity != null
                      ? Container(
                          margin: EdgeInsets.only(top: 10),
                          child: AreaDropdown(
                              showAll: true,
                              selectedCity: model.selectedArea == null
                                  ? 99
                                  : model.selectedArea!.id,
                              cubit: model.areaCubit,
                              onChanged: (value) {
                                model.onAreaCahanged(context, data: value);
                              }),
                        )
                      : Container()
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ServiceCubit, ServiceState>(
                bloc: model.serviceCubit,
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return Expanded(
                        child: Center(
                            child: Container(
                      alignment: Alignment.center,
                      child: showLoading(cc.primaryColor),
                    )));
                  } else if (state is ServiceLoaded) {
                    if (state.data.isNotEmpty) {
                      List<Widget> dataFinalWidget = [];

                      state.data.forEach((element) {
                        bool showContent = false;

                        // String hehe = '';

                        if (model.selectedCity == null) {
                          showContent = true;
                        } else {
                          if (model.selectedCity!.serviceCity ==
                              element.cityName) {
                            if (model.selectedArea == null) {
                              showContent = true;
                            } else {
                              if (model.selectedArea!.area ==
                                  element.areaName) {
                                showContent = true;
                              }
                            }
                          }
                        }

                        if (showContent) {
                          dataFinalWidget.add(ServiceCard(
                            data: element,
                            isSplit: true,
                          ));
                        }
                      });

                      return dataFinalWidget.isEmpty
                          ? Expanded(
                              child:
                                  Center(child: Text('Data Tidak Ditemukan')))
                          : Expanded(
                              child: LazyLoadScrollView(
                              onEndOfPage: () {
                                // if (!provider.lastPage) {
                                //   Provider.of<ServiceByCategoryService>(context,
                                //           listen: false)
                                //       .fetchCategoryService(
                                //           context, widget.categoryId,
                                //           page: provider.currentPage + 1,
                                //           stateId: selected?['id']);
                                // }
                              },
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  model.onInit(context, id: widget.categoryId);
                                },
                                child: ListView(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    width: double.infinity,
                                    alignment: state.data.length == 1
                                        ? Alignment.centerLeft
                                        : Alignment.center,
                                    child: Wrap(children: dataFinalWidget),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ]),
                              ),
                            ));
                    } else {
                      return Expanded(
                          child: Center(child: Text('Data Tidak Ditemukan')));
                    }
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      );
    });
  }
}
