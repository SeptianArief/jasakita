import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/textarea_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  final String orderId;
  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  double rating = 1;
  TextEditingController reviewController = TextEditingController();
  bool requestLoading = false;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Tulis Ulasan', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 15,
            ),
            // ServiceTitleAndUser(
            //   cc: cc,
            //   title: widget.title,
            //   userImg: widget.userImg,
            //   sellerName: widget.userName,
            //   sellerId: '',
            //   videoLink: null,
            //   onTap: () {},
            // ),

            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
              itemSize: 32,
              unratedColor: cc.greyFive,
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                rating = value;
                print(rating);
              },
            ),
            SizedBox(height: 20),
            Text(
              'Bagaimana pesanan Anda?',
              style: mainFont.copyWith(
                  color: cc.greyFour,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 14,
            ),
            TextareaField(
              notesController: reviewController,
              hintText: 'Tulis Ulasan Anda',
            ),
            const SizedBox(
              height: 20,
            ),

            CommonHelper().buttonOrange('Kirim Ulasan', () {
              if (!requestLoading) {
                setState(() {
                  requestLoading = true;
                });
                ProfileState state =
                    BlocProvider.of<ProfileCubit>(context).state;
                if (state is ProfileLoaded) {
                  OrderService.writeReview(context,
                          rating: rating.toStringAsFixed(0),
                          name: state.data.detail.name,
                          email: state.data.detail.email,
                          message: reviewController.text,
                          orderId: widget.orderId)
                      .then((value) {
                    setState(() {
                      requestLoading = false;
                    });
                    if (value.status == RequestStatus.successRequest) {
                      FormHelper.showSnackbar(context,
                          data: value.data ?? 'Berhasil mengirim ulasan',
                          colors: Colors.green);
                      Navigator.pop(context);
                    } else {
                      if (value.data != null) {
                        if (value.data.contains('already')) {
                          FormHelper.showSnackbar(context,
                              data:
                                  'Anda sudah melakukan review untuk pesanan ini',
                              colors: Colors.orange);
                        } else {
                          FormHelper.showSnackbar(context,
                              data:
                                  'Pesanan harus dalam status selesai untuk di review',
                              colors: Colors.orange);
                        }
                      } else {
                        FormHelper.showSnackbar(context,
                            data: 'Gagal melakukan review',
                            colors: Colors.orange);
                      }
                    }
                  });
                }
              }
            }, isloading: requestLoading),
          ]),
        ),
      ),
    );
  }
}
