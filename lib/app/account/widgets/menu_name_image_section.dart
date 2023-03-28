import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/account/pages/profile_edit_page.dart';
import 'package:qixer/app/account/pages/setting_helper.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';

class MenuNameImageSection extends StatelessWidget {
  const MenuNameImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return BlocBuilder<ProfileCubit, ProfileState>(
        bloc: BlocProvider.of<ProfileCubit>(context),
        builder: (context, state) => state is ProfileLoaded
            ? Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //profile image, name ,desc
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              //Profile image section =======>
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ProfileEditPage(),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    state.data.detail.image != null
                                        ? CommonHelper().profileImage(
                                            state.data.detail.image!, 62, 62)
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/avatar.png',
                                              height: 62,
                                              width: 62,
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                    const SizedBox(
                                      height: 12,
                                    ),

                                    //user name
                                    CommonHelper()
                                        .titleCommon(state.data.detail.name),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    //phone
                                    CommonHelper().paragraphCommon(
                                        state.data.detail.phone,
                                        TextAlign.center),

                                    state.data.detail.about != null
                                        ? CommonHelper().paragraphCommon(
                                            state.data.detail.about!,
                                            TextAlign.center)
                                        : Container(),
                                  ],
                                ),
                              ),

                              // //Grid cards
                              GridView.builder(
                                gridDelegate: const FlutterzillaFixedGridView(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    height: 70),
                                padding: const EdgeInsets.only(top: 30),
                                itemCount: 4,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: cc.borderColor),
                                    ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            SettingsHelper()
                                                .cardContent[index]
                                                .iconLink,
                                            height: 35,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CommonHelper().titleCommon(
                                                  index == 0
                                                      ? state.data.pendingOrder
                                                          .toString()
                                                      : index == 1
                                                          ? state
                                                              .data.activeOrder
                                                              .toString()
                                                          : index == 2
                                                              ? state.data
                                                                  .completeOrder
                                                                  .toString()
                                                              : state.data
                                                                  .totalOrder
                                                                  .toString(),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  SettingsHelper()
                                                      .cardContent[index]
                                                      .text,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: mainFont.copyWith(
                                                    color: cc.greyParagraph,
                                                    height: 1.4,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ]),
                                  );
                                },
                              ),
                            ],
                          ),

                          //
                        ]),
                  ),
                  // SettingsHelper().borderBold(30, 20),
                ],
              )
            : Container(
                margin: EdgeInsets.symmetric(vertical: 100),
                child: showLoading(cc.primaryColor)));
  }
}
