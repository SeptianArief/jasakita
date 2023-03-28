import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/home/cubits/slider_cubit/slider_cubit.dart';
import 'package:qixer/app/home/cubits/slider_cubit/slider_state.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/shared/widget_helper.dart';

class SliderSection extends StatelessWidget {
  final HomeVM model;
  const SliderSection({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SliderCubit, SliderState>(
        bloc: model.sliderCubit,
        builder: (context, state) {
          if (state is SliderLoaded) {
            return SizedBox(
              height: 175,
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: state.data.length,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  initialPage: 1,
                ),
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: state.data[itemIndex].imageUrl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Consumer<RtlService>(
                    //   builder: (context, rtlP, child) => Positioned(
                    //       left: rtlP.direction == 'ltr' ? 25 : 0,
                    //       right: rtlP.direction == 'ltr' ? 0 : 25,
                    //       top: 20,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             width: MediaQuery.of(context).size.width / 2,
                    //             child: Text(
                    //               sliderDetailsList[itemIndex]['title'],
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis,
                    //               style: mainFont.copyWith(
                    //                   color: cc.greyFour,
                    //                   fontSize: 21,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             height: 7,
                    //           ),
                    //           Container(
                    //             width: MediaQuery.of(context).size.width / 2 - 20,
                    //             child: Text(
                    //               sliderDetailsList[itemIndex]['subtitle'],
                    //               maxLines: 2,
                    //               overflow: TextOverflow.ellipsis,
                    //               style: mainFont.copyWith(
                    //                   color: cc.greyFour, fontSize: 14, height: 1.3),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             height: 7,
                    //           ),
                    //           // ElevatedButton(
                    //           //     style: ElevatedButton.styleFrom(
                    //           //         primary: cc.greyFour, elevation: 0),
                    //           //     onPressed: () {},
                    //           //     child: const Text('Get now'))
                    //         ],
                    //       )),
                    // )
                  ],
                ),
              ),
            );
          } else if (state is SliderLoading) {
            return showLoading(Theme.of(context).primaryColor);
          } else {
            return Container();
          }
        });
  }
}
