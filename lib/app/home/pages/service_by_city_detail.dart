import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:provider/provider.dart';
import 'package:qixer/app/auth/widgets/area_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/app/home/vm/service_by_categories_vm.dart';
import 'package:qixer/app/home/widgets/service_card.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:stacked/stacked.dart';

class ServiceByCityDetailPage extends StatefulWidget {
  final String title;
  final List<ServiceModel> data;

  const ServiceByCityDetailPage(
      {Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  State<ServiceByCityDetailPage> createState() =>
      _ServiceByCityDetailPageState();
}

class _ServiceByCityDetailPageState extends State<ServiceByCityDetailPage> {
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon(widget.title, context, () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          Expanded(
              child: ListView(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              alignment: widget.data.length == 1
                  ? Alignment.centerLeft
                  : Alignment.center,
              child: Wrap(
                children: List.generate(widget.data.length, (i) {
                  return ServiceCard(
                    data: widget.data[i],
                    isSplit: true,
                  );
                }),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ]))
        ],
      ),
    );
  }
}
