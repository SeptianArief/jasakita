import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qixer/app/account/pages/profile_edit_page.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/home/pages/service_search_page.dart';
import 'package:qixer/app/home/vm/home_vm.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';

class ProfileSection extends StatelessWidget {
  final HomeVM model;
  const ProfileSection({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ProfileEditPage(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                //name
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lokasi',
                      style: mainFont.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.getLocationMaster(context),
                      style: mainFont.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )),

                //profile image
                BlocBuilder<ProfileCubit, ProfileState>(
                    bloc: BlocProvider.of<ProfileCubit>(context),
                    builder: (context, state) {
                      if (state is ProfileLoaded) {
                        if (state.data.detail.image != null) {
                          return CommonHelper()
                              .profileImage(state.data.detail.image!, 62, 62);
                        }
                      }
                      return Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/avatar.png'))),
                      );
                    })
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ServiceSearchPage()));
          },
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          spreadRadius: -2,
                          blurRadius: 13,
                          offset: const Offset(0, 13)),
                    ],
                    borderRadius: BorderRadius.circular(40)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 126, 126, 126),
                      size: 22,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cari jasa apa?",
                      style: mainFont.copyWith(
                        color: Color.fromARGB(255, 126, 126, 126),
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}
