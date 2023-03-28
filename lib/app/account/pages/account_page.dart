import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/account/pages/change_password_page.dart';
import 'package:qixer/app/account/pages/my_ticket_page.dart';
import 'package:qixer/app/account/pages/profile_edit_page.dart';
import 'package:qixer/app/account/pages/report_list_page.dart';
import 'package:qixer/app/account/pages/setting_helper.dart';
import 'package:qixer/app/account/widgets/menu_name_image_section.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/widget_helper.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          RefreshIndicator(
            onRefresh: () async {
              UserState userState = BlocProvider.of<UserCubit>(context).state;
              if (userState is UserLogged) {
                BlocProvider.of<ProfileCubit>(context).fetchProfile(context,
                    token: userState.user.token, refresh: true);
              }
            },
            child: ListView(
              children: [
                //
                const MenuNameImageSection(),

                // Personal information ==========>
                // const MenuPersonalInfoSection(),

                SettingsHelper().borderBold(35, 8),

                //Other settings options ========>
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    SettingsHelper().settingOption(
                        'assets/svg/message-circle.svg', "Tiket Bantuan", () {
                      //=====>
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const MyTicketsPage(),
                        ),
                      );
                    }),
                    CommonHelper().dividerCommon(),
                    SettingsHelper().settingOption(
                        'assets/svg/profile-edit.svg', "Laporan Saya", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const MyReportListPage(),
                        ),
                      );
                    }),
                    CommonHelper().dividerCommon(),
                    SettingsHelper().settingOption(
                        'assets/svg/profile-edit.svg', "Ubah Identitas", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ProfileEditPage(),
                        ),
                      );
                    }),
                    CommonHelper().dividerCommon(),
                    SettingsHelper().settingOption(
                        'assets/svg/lock-circle.svg', "Ubah Password", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ChangePasswordPage(),
                        ),
                      );
                    }),
                  ]),
                ),

                // logout
                SettingsHelper().borderBold(12, 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    SettingsHelper().settingOption(
                        'assets/svg/logout-circle.svg', "Keluar", () {
                      SettingsHelper().logoutPopup(context);
                    }),
                    SizedBox(
                      height: 20,
                    )
                  ]),
                )
              ],
            ),
          ),
        ]),
      ),
    );

    //chat icon ========>
    // const ChatIcon(),
  }
}
