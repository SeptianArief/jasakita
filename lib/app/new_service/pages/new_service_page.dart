import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/widgets/categories_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/models/categories_model.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/widgets/service_card.dart';
import 'package:qixer/app/new_service/vm/new_service_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class NewestTab extends StatefulWidget {
  const NewestTab({Key? key}) : super(key: key);

  @override
  _NewestTabState createState() => _NewestTabState();
}

class _NewestTabState extends State<NewestTab> {
  ServiceCubit serviceCubit = ServiceCubit();
  Categories? selectedCategory;
  City? selectedCity;

  @override
  void initState() {
    super.initState();
    serviceCubit.fetchNewestService(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return ViewModelBuilder<NewServiceVM>.reactive(viewModelBuilder: () {
      return NewServiceVM();
    }, onViewModelReady: (model) {
      model.onInit(context);
    }, builder: (context, model, child) {
      return Listener(
          onPointerDown: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.none,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      CommonHelper().titleCommon('Jasa Terbaru'),
                      SizedBox(height: 20),
                      CategoriesDropdown(
                        cubit: model.categoriesCubit,
                        onChanged: (value) {
                          if (value.id == 99) {
                            setState(() {
                              selectedCategory = null;
                            });
                          } else {
                            setState(() {
                              selectedCategory = value;
                            });
                          }
                        },
                        selectedCity: selectedCategory == null
                            ? 99
                            : selectedCategory!.id,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownCityAll(
                        onChanged: (value) {
                          if (value.id == 99) {
                            setState(() {
                              selectedCity = null;
                            });
                          } else {
                            setState(() {
                              selectedCity = value;
                            });
                          }
                        },
                        selectedCity:
                            selectedCity == null ? 99 : selectedCity!.id,
                        showAll: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<ServiceCubit, ServiceState>(
                          bloc: model.serviceCubit,
                          builder: (context, state) {
                            if (state is ServiceLoaded) {
                              List<ServiceModel> dataFinal = state.data;

                              List<Widget> dataWidgetFinal = [];

                              for (var i = 0; i < dataFinal.length; i++) {
                                bool showData = false;

                                if (selectedCity == null) {
                                  if (selectedCategory == null) {
                                    showData = true;
                                  } else {
                                    if (selectedCategory!.id.toString() ==
                                        dataFinal[i].categoryId) {
                                      showData = true;
                                    }
                                  }
                                } else {
                                  if (selectedCity!.serviceCity ==
                                      dataFinal[i].cityName) {
                                    if (selectedCategory == null) {
                                      showData = true;
                                    } else {
                                      if (selectedCategory!.id.toString() ==
                                          dataFinal[i].categoryId) {
                                        showData = true;
                                      }
                                    }
                                  }
                                }

                                if (showData) {
                                  dataWidgetFinal.add(
                                    ServiceCard(
                                      data: dataFinal[i],
                                      isSplit: true,
                                    ),
                                  );
                                }
                              }

                              if (dataWidgetFinal.isEmpty) {
                                return const Expanded(
                                  child: Center(
                                      child: Text('Data Tidak Ditemukan')),
                                );
                              } else {
                                return Expanded(
                                    child: RefreshIndicator(
                                  color: cc.primaryColor,
                                  onRefresh: () async {
                                    serviceCubit.fetchNewestService(context);
                                  },
                                  child: ListView(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            runSpacing: 20,
                                            children: dataWidgetFinal),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                ));
                              }
                            } else if (state is ServiceLoading) {
                              return showLoading(cc.primaryColor);
                            } else {
                              return Container();
                            }
                          })
                    ]),
              ),
            ),
          ));
    });
  }
}
