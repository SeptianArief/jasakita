import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/account/pages/report_chat_page.dart';
import 'package:qixer/app/account/vm/report_message_service.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/widget_helper.dart';

class MyReportListPage extends StatefulWidget {
  const MyReportListPage({Key? key}) : super(key: key);

  @override
  _MyReportListPageState createState() => _MyReportListPageState();
}

class _MyReportListPageState extends State<MyReportListPage> {
  OrderCubit reportCubit = OrderCubit();
  @override
  void initState() {
    reportCubit.fetchReportList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Laporan', context, () {
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: LazyLoadScrollView(
            onEndOfPage: () async {
              OrderState state = reportCubit.state;
              if (state is ReportListLoaded) {
                reportCubit.fetchReportList(context, currState: state);
              }
            },
            child: RefreshIndicator(
              onRefresh: () async {
                reportCubit.fetchReportList(context);
              },
              child: ListView(
                children: [
                  BlocBuilder<OrderCubit, OrderState>(
                      bloc: reportCubit,
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return showLoading(cc.primaryColor);
                        } else if (state is ReportListLoaded) {
                          return state.data.data.isNotEmpty
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < state.data.data.length;
                                          i++)
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 3,
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 3),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: cc.borderColor),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //Ticket title
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonHelper()
                                                            .labelCommon(
                                                          'Id Laporan: ${state.data.data[i].id}',
                                                        ),
                                                        CommonHelper()
                                                            .labelCommon(
                                                          'Order id: ${state.data.data[i].orderId}',
                                                        ),
                                                      ],
                                                    )),
                                                    SizedBox(
                                                      width: 100,
                                                      child: CommonHelper()
                                                          .buttonOrange(
                                                              'Chat admin', () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute<
                                                              void>(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ReportChatPage(
                                                              title: state
                                                                  .data
                                                                  .data[i]
                                                                  .reportMessage,
                                                              ticketId: state
                                                                  .data
                                                                  .data[i]
                                                                  .id,
                                                            ),
                                                          ),
                                                        );
                                                        //fetch message
                                                        Provider.of<ReportMessagesService>(
                                                                context,
                                                                listen: false)
                                                            .fetchMessages(state
                                                                .data
                                                                .data[i]
                                                                .id);
                                                      }, paddingVerticle: 10),
                                                    )
                                                  ],
                                                ),

                                                FormHelper.splitRow(
                                                    title: 'Laporan',
                                                    data: state.data.data[i]
                                                        .reportMessage),
                                                FormHelper.splitRow(
                                                    title: 'Waktu Laporan',
                                                    data: dateToReadable(state
                                                        .data.data[i].createdAt
                                                        .substring(0, 10))),

                                                SizedBox(
                                                  height: 15,
                                                )
                                              ]),
                                        )
                                    ],
                                  ),
                                )
                              : CommonHelper()
                                  .nothingfound(context, 'Tidak Ada Laporan');
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
