import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/model/order_model.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/custom_input.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';
import 'package:qixer/shared/textarea_field.dart';
import 'package:qixer/shared/widget_helper.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({Key? key}) : super(key: key);

  @override
  _CreateTicketPageState createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  bool ticketLoading = false;
  OrderCubit orderCubit = OrderCubit();

  @override
  void initState() {
    orderCubit.fetchOrder(context);
    super.initState();
  }

  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  var priorityDropdownList = ['Mendesak', 'Tinggi', 'Sedang', 'Rendah'];
  String selectedPriority = 'Mendesak';
  String? selectedOrder;
  OrderPreview? selectedOrderData;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Buat Tiket', context, () {
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(true);
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Priority dropdown ======>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().labelCommon("Prioritas"),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: cc.greyFive),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                // menuMaxHeight: 200,
                                // isExpanded: true,
                                value: selectedPriority,
                                icon: Icon(Icons.keyboard_arrow_down_rounded,
                                    color: cc.greyFour),
                                iconSize: 26,
                                elevation: 17,
                                style: mainFont.copyWith(color: cc.greyFour),
                                onChanged: (newValue) {},
                                items: priorityDropdownList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: mainFont.copyWith(
                                          color:
                                              cc.greyPrimary.withOpacity(.8)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),

                      //Order dropdown =======>
                      BlocBuilder<OrderCubit, OrderState>(
                          bloc: orderCubit,
                          builder: (context, state) {
                            if (state is OrderLoading) {
                              return Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: showLoading(cc.primaryColor));
                            } else if (state is OrderLoaded) {
                              if (state.data.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CommonHelper().labelCommon("Nomor Pesanan"),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: cc.greyFive),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          // menuMaxHeight: 200,
                                          // isExpanded: true,
                                          value: selectedOrder,
                                          icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: cc.greyFour),
                                          iconSize: 26,
                                          elevation: 17,
                                          style: mainFont.copyWith(
                                              color: cc.greyFour),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedOrder = newValue;
                                              state.data.forEach((element) {
                                                if ('#${element.id}' ==
                                                    newValue) {
                                                  selectedOrderData = element;
                                                }
                                              });
                                            });
                                          },
                                          hint: Text('Pilih Pesanan Anda'),
                                          items: List.generate(
                                              state.data.length, (index) {
                                            return DropdownMenuItem(
                                              value: '#${state.data[index].id}',
                                              child: Text(
                                                '#${state.data[index].id}',
                                                style: mainFont.copyWith(
                                                    color: cc.greyPrimary
                                                        .withOpacity(.8)),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Anda tidak memiliki pesanan aktif',
                                      style: mainFont.copyWith(
                                          color: cc.warningColor),
                                    ));
                              }
                            } else {
                              return Container();
                            }
                          }),

                      SizedBox(
                        height: 20,
                      ),
                      CommonHelper().labelCommon("Judul"),
                      CustomInput(
                        controller: titleController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon mengisi judul ticket';
                          }
                          return null;
                        },
                        hintText: "Judul Ticket",
                        // icon: 'assets/icons/user.png',
                        paddingHorizontal: 18,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      CommonHelper().labelCommon("Deskripsi"),
                      TextareaField(
                        hintText: 'Mohon jelaskan kendala Anda',
                        notesController: descController,
                      ),

                      //Save button =========>

                      const SizedBox(
                        height: 30,
                      ),
                      CommonHelper().buttonOrange('Buat Tiket', () {
                        OrderState state = orderCubit.state;
                        if (state is OrderLoaded) {
                          if (state.data.isEmpty) {
                            FormHelper.showSnackbar(context,
                                data: 'Anda tidak memiliki pesanan aktif',
                                colors: Colors.orange);
                          } else if (_formKey.currentState!.validate()) {
                            if (selectedOrder == null) {
                              FormHelper.showSnackbar(context,
                                  data: 'Mohon memilih pesanan yang bermasalah',
                                  colors: Colors.orange);
                            } else {
                              if (!ticketLoading) {
                                setState(() {
                                  ticketLoading = true;
                                });

                                OrderService.createTicket(context,
                                        subject: titleController.text,
                                        priority: selectedPriority,
                                        orderId: selectedOrder!.substring(1),
                                        desc: descController.text)
                                    .then((value) {
                                  setState(() {
                                    ticketLoading = false;
                                  });
                                  if (value.status ==
                                      RequestStatus.successRequest) {
                                    FormHelper.showSnackbar(context,
                                        data: 'Berhasil menambahkan tiket',
                                        colors: Colors.green);
                                    Navigator.pop(context, true);
                                  } else {
                                    FormHelper.showSnackbar(context,
                                        data:
                                            value.data ?? 'Gagal membuat tiket',
                                        colors: Colors.orange);
                                  }
                                });
                              }
                            }
                          }
                        }
                      }, isloading: ticketLoading)
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
