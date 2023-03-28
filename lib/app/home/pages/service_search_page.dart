import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/widgets/service_card.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/widget_helper.dart';

class ServiceSearchPage extends StatefulWidget {
  const ServiceSearchPage({Key? key}) : super(key: key);

  @override
  State<ServiceSearchPage> createState() => _ServiceSearchPageState();
}

class _ServiceSearchPageState extends State<ServiceSearchPage> {
  ConstantColors cc = ConstantColors();
  TextEditingController searchController = TextEditingController();
  ServiceCubit searchCubit = ServiceCubit();
  City? selectedCity;
  Timer? _debounce;

  searchSearch(String val) {
    searchCubit.searchService(context,
        cityId: selectedCity == null ? '' : selectedCity!.id.toString(),
        search: val);
  }

  @override
  void initState() {
    searchSearch('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          child: CommonHelper().titleCommon('Cari Jasa'),
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    spreadRadius: -2,
                    blurRadius: 13,
                    offset: const Offset(0, 13)),
              ],
              borderRadius: BorderRadius.circular(3)),
          child: TextFormField(
            controller: searchController,
            autofocus: true,
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                if (value.isNotEmpty) {
                  searchSearch(value);
                }
              });
            },
            style: mainFont.copyWith(fontSize: 14),
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari',
                hintStyle:
                    mainFont.copyWith(color: cc.greyPrimary.withOpacity(.8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownCityAll(
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
              searchSearch(searchController.text);
            },
            selectedCity: selectedCity == null ? 99 : selectedCity!.id,
            showAll: true,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: BlocBuilder<ServiceCubit, ServiceState>(
          bloc: searchCubit,
          builder: (context, state) {
            if (state is ServiceLoading) {
              return Center(
                child: showLoading(cc.primaryColor),
              );
            } else if (state is ServiceLoaded) {
              return state.data.isEmpty
                  ? Center(
                      child: Text(
                        'Data tidak ditemukan',
                        style: mainFont.copyWith(fontSize: 13),
                      ),
                    )
                  : ListView(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        alignment: state.data.length == 1
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: Wrap(
                          children: List.generate(state.data.length, (i) {
                            bool showContent = true;

                            // String hehe = '';

                            // if (selected2 == null) {
                            //   showContent = true;
                            // } else {
                            //   hehe = selected2['service_area'] +
                            //       ' : ' +
                            //       provider.serviceMap[i]
                            //           ['service_area_name'];
                            //   if (selected2['service_area'] ==
                            //       provider.serviceMap[i]['areaValue']) {
                            //     showContent = true;
                            //   }
                            // }

                            // String dataImageseller = placeHolderUrl;

                            // try {
                            //   dataImageseller = provider.serviceMap[i]
                            //       ['seller']['image']['img_url'];
                            // } catch (e) {}

                            return !showContent
                                ? Container()
                                : ServiceCard(
                                    data: state.data[i],
                                    isSplit: true,
                                  );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ]);
            } else {
              return Container();
            }
          },
        ))
      ],
    ));
  }
}
