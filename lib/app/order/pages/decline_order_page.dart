import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/home/services/service_service.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';
import 'package:qixer/shared/textarea_field.dart';

class DeclineOrderPage extends StatefulWidget {
  const DeclineOrderPage(
      {Key? key,
      required this.orderId,
      required this.sellerId,
      required this.fcmToken})
      : super(key: key);

  final orderId;
  final fcmToken;
  final sellerId;

  @override
  State<DeclineOrderPage> createState() => _DeclineOrderPageState();
}

class _DeclineOrderPageState extends State<DeclineOrderPage> {
  TextEditingController controller = TextEditingController();
  bool cancelLoading = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Tolak', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 20),
            Text(
              'Mohon jelaskan mengapa pesanan ini belum bisa dikatakan selesai',
              style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            TextareaField(
              notesController: controller,
              hintText: 'Alasan Penolakan',
            ),
            SizedBox(height: 30),
            CommonHelper().buttonOrange('Tolak', () {
              if (cancelLoading) return;

              if (controller.text.length < 20) {
                FormHelper.showSnackbar(context,
                    data: 'Mohon mengisi alasan penolakan minimal 20 karakter',
                    colors: Colors.orange);
                return;
              }

              FocusManager.instance.primaryFocus?.unfocus();

              setState(() {
                cancelLoading = true;
              });

              ServiceService.declineOrder(context,
                      reason: controller.text,
                      sellerId: widget.sellerId,
                      orderId: widget.orderId)
                  .then((value) {
                setState(() {
                  cancelLoading = false;
                });
                if (value.status == RequestStatus.successRequest) {
                  ProfileState profileState =
                      BlocProvider.of<ProfileCubit>(context).state;
                  if (profileState is ProfileLoaded) {
                    PushNotificationService().sendNotificationToSellerByToken(
                        context,
                        token: widget.fcmToken,
                        title:
                            "${profileState.data.detail.name} telah menolak permintaan selesai pesanan",
                        body: 'Id Pesanan: ${widget.orderId}');
                  }

                  FormHelper.showSnackbar(context,
                      data: 'Berhasil menolak selesai pesanan',
                      colors: Colors.green);
                  Navigator.pop(context, true);
                } else {
                  FormHelper.showSnackbar(context,
                      data: 'Gagal melakukan perubahan data, mohon coba lagi',
                      colors: Colors.orange);
                }
              });
            }, bgColor: Colors.red, isloading: cancelLoading),
          ]),
        ),
      ),
    );
  }
}
