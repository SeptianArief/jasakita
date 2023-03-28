import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/order/pages/order_page.dart';
import 'package:qixer/app/service/widgets/about_seller_tab.dart';
import 'package:qixer/app/service/widgets/image_big.dart';
import 'package:qixer/app/service/widgets/overview_tab.dart';
import 'package:qixer/app/service/widgets/review_tab.dart';
import 'package:qixer/app/service/widgets/service_detail_top_widget.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String serviceId;
  const ServiceDetailsPage({Key? key, required this.serviceId})
      : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;
  ServiceCubit serviceCubit = ServiceCubit();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    serviceCubit.fetchDetail(context, id: widget.serviceId);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Provider.of<ServiceDetailsService>(context, listen: false)
    //     .fetchServiceDetails(widget.serviceId);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ServiceCubit, ServiceState>(
            bloc: serviceCubit,
            builder: (context, state) {
              if (state is ServiceLoading) {
                return Center(
                  child: showLoading(cc.primaryColor),
                );
              } else if (state is ServiceDetailLoaded) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Column(
                            children: [
                              // Image big
                              ImageBig(
                                serviceName: state.data.title,
                                imageLink: state.data.image,
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              //Top part
                              ServiceDetailsTop(
                                cc: cc,
                                data: state.data,
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              children: <Widget>[
                                TabBar(
                                  onTap: (value) {
                                    setState(() {
                                      currentTab = value;
                                    });
                                  },
                                  labelColor: cc.primaryColor,
                                  unselectedLabelColor: cc.greyFour,
                                  indicatorColor: cc.primaryColor,
                                  unselectedLabelStyle: mainFont.copyWith(
                                      color: cc.greyParagraph,
                                      fontWeight: FontWeight.normal),
                                  controller: _tabController,
                                  tabs: [
                                    Tab(text: 'Ringkasan'),
                                    Tab(text: 'Tentang Vendor'),
                                    Tab(text: 'Review'),
                                  ],
                                ),
                                Container(
                                  child: [
                                    OverviewTab(data: state.data),
                                    AboutSellerTab(
                                      data: state.data,
                                    ),
                                    ReviewTab(data: state.data),
                                  ][_tabIndex],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Book now button
                    CommonHelper().dividerCommon(),
                    //Button
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // currentTab == 2
                            //     ? Column(
                            //         children: [
                            //           CommonHelper().borderButtonOrange(
                            //               asProvider.getString(
                            //                   'Write a review'), () {
                            //             Navigator.push(
                            //               context,
                            //               MaterialPageRoute<void>(
                            //                 builder:
                            //                     (BuildContext context) =>
                            //                         WriteReviewPage(
                            //                   serviceId: provider
                            //                       .serviceAllDetails
                            //                       .serviceDetails
                            //                       .id,
                            //                 ),
                            //               ),
                            //             );
                            //           }),
                            //           const SizedBox(
                            //             height: 14,
                            //           ),
                            //         ],
                            //       )
                            //     : Container(),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      CommonHelper().buttonOrange('Pesan', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ServicePersonalizationPage(
                                                  serviceId:
                                                      state.data.id.toString(),
                                                  brands: state.data.brands,
                                                )));
                                  }),
                                ),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }));
  }
}
