import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/account/pages/create_ticket_page.dart';
import 'package:qixer/app/account/pages/ticket_message_page.dart';
import 'package:qixer/app/account/vm/support_message_service.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/widgets/order_helper.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({Key? key}) : super(key: key);

  @override
  _MyTicketsPageState createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  OrderCubit ticketCubit = OrderCubit();

  @override
  void initState() {
    ticketCubit.fetchTicketList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: cc.greyPrimary),
        title: Text(
          'Tiket Bantuan',
          style: mainFont.copyWith(
              color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width / 4,
            padding: const EdgeInsets.symmetric(
              vertical: 9,
            ),
            child: InkWell(
              onTap: () async {
                bool? result = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CreateTicketPage()));

                if (result != null) {
                  // ignore: use_build_context_synchronously
                  ticketCubit.fetchTicketList(context);
                }
              },
              child: Container(
                  // width: double.infinity,

                  alignment: Alignment.center,
                  // padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: cc.primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'Buat',
                    maxLines: 1,
                    style: mainFont.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  )),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      body: LazyLoadScrollView(
        onEndOfPage: () {
          OrderState state = ticketCubit.state;
          if (state is TicketListLoaded) {
            ticketCubit.fetchTicketList(context, currentState: state);
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            ticketCubit.fetchTicketList(context);
          },
          child: ListView(
            children: [
              BlocBuilder<OrderCubit, OrderState>(
                  bloc: ticketCubit,
                  builder: (context, state) {
                    if (state is OrderLoading) {
                      return showLoading(cc.primaryColor);
                    } else if (state is TicketListLoaded) {
                      if (state.data.data.isEmpty) {
                        return CommonHelper()
                            .nothingfound(context, 'Tidak ada tiket');
                      } else {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < state.data.data.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            TicketChatPage(
                                                title: state.data.data[i].title,
                                                ticketId: state.data.data[i].id,
                                                sellerId: state
                                                    .data.data[i].seller_id),
                                      ),
                                    );
                                    Future.delayed(Duration(milliseconds: 0),
                                        () {
                                      Provider.of<SupportMessagesService>(
                                              context,
                                              listen: false)
                                          .fetchMessages(state.data.data[i].id);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 3,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: cc.borderColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '#${state.data.data[i].id}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: mainFont.copyWith(
                                                  color: cc.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),

                                          //Ticket title
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          CommonHelper().titleCommon(
                                              state.data.data[i].title),
                                          CommonHelper().labelCommon(
                                              state.data.data[i].desc),

                                          //Divider
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 0, bottom: 20),
                                            child:
                                                CommonHelper().dividerCommon(),
                                          ),
                                          //Capsules
                                          Row(
                                            children: [
                                              OrdersHelper().statusCapsule(
                                                  state.data.data[i].priority,
                                                  cc.greyThree),
                                              const SizedBox(
                                                width: 11,
                                              ),
                                              OrdersHelper()
                                                  .statusCapsuleBordered(
                                                      state.data.data[i].status,
                                                      cc.greyParagraph),
                                            ],
                                          )
                                        ]),
                                  ),
                                )
                            ],
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
