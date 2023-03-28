import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/app/auth/widgets/area_dropdown.dart';
import 'package:qixer/app/auth/widgets/city_dropdown.dart';
import 'package:qixer/shared/common_helper.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/constant_color.dart';
import 'package:qixer/shared/cubits/area_master/area_cubit.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/custom_input.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/textarea_field.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController postCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String? countryCode;
  String? currentProfile;

  City? selectedCity;
  Area? selectedArea;
  AreaCubit areaCubit = AreaCubit();

  bool isloading = false;

  XFile? pickedImage;

  refreshDataArea(String city) {
    areaCubit.fetchArea(context, idCity: city);
  }

  @override
  void initState() {
    ProfileState profileState = BlocProvider.of<ProfileCubit>(context).state;

    if (profileState is ProfileLoaded) {
      fullNameController.text = profileState.data.detail.name;
      emailController.text = profileState.data.detail.email;
      phoneController.text = profileState.data.detail.phone;
      postCodeController.text = profileState.data.detail.postalCode;
      addressController.text = profileState.data.detail.address;
      selectedCity = profileState.data.detail.city;
      selectedArea = profileState.data.detail.area;
      currentProfile = profileState.data.detail.image;

      refreshDataArea(selectedCity!.id.toString());
    }

    super.initState();
  }

  late AnimationController localAnimationController;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Ubah Identitas', context, () {
        if (isloading == false) {
          Navigator.pop(context);
        } else {
          FormHelper.showSnackbar(context,
              data: 'Mohon tunggu, Data sedang diperbarui',
              colors: Colors.black);
        }
      }),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: WillPopScope(
          onWillPop: () {
            if (isloading == false) {
              return Future.value(true);
            } else {
              FormHelper.showSnackbar(context,
                  data: 'Mohon tunggu, Data sedang diperbarui',
                  colors: Colors.black);
              return Future.value(false);
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //pick profile image
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      // Capture a photo
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.gallery);

                      if (photo != null) {
                        setState(() {
                          pickedImage = photo;
                        });
                      }
                      // pickedImage = await provider.pickImage();
                      // setState(() {});
                    },
                    child: SizedBox(
                      width: 105,
                      height: 105,
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: pickedImage == null
                                    ? currentProfile != null
                                        ? CommonHelper().profileImage(
                                            currentProfile!, 85, 85)
                                        : Image.asset(
                                            'assets/images/avatar.png',
                                            height: 85,
                                            width: 85,
                                            fit: BoxFit.cover,
                                          )
                                    : Image.file(
                                        File(pickedImage!.path),
                                        height: 85,
                                        width: 85,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Positioned(
                            bottom: 9,
                            right: 12,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                  child: Icon(
                                Icons.camera,
                                color: cc.greyPrimary,
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //Email, name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Name ============>
                      CommonHelper().labelCommon('Nama Lengkap'),

                      CustomInput(
                        controller: fullNameController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon memasukkan nama lengkap';
                          }
                          return null;
                        },
                        hintText: 'Masukkan nama lengkap',
                        icon: 'assets/icons/user.png',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 18,
                      ),

                      //Email ============>
                      CommonHelper().labelCommon('Email'),

                      CustomInput(
                        controller: emailController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan email Anda';
                          }
                          return null;
                        },
                        hintText: "Masukkan email Anda",
                        icon: 'assets/icons/email-grey.png',
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),

                  //phone
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonHelper().labelCommon('Nomor Handphone'),
                      CustomInput(
                        controller: phoneController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan nomor handphone Anda';
                          }
                          return null;
                        },
                        hintText: "Masukkan nomor handphone Anda",
                        icon: 'assets/icons/email-grey.png',
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 20),
                      CommonHelper().labelCommon('Kode Pos'),
                      CustomInput(
                        controller: postCodeController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon masukkan kode pos';
                          }
                          return null;
                        },
                        isNumberField: true,
                        hintText: 'Masukkan kode pos',
                        icon: 'assets/icons/user.png',
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: CommonHelper().labelCommon('Kota')),

                  //dropdowns
                  DropdownCityAll(
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                        areaCubit.fetchArea(context,
                            idCity: value.id.toString());
                        selectedArea = null;
                      });
                    },
                    showAll: false,
                    selectedCity: selectedCity?.id,
                  ),

                  selectedCity == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              'Pilih Area',
                              style: mainFont.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AreaDropdown(
                                cubit: areaCubit,
                                selectedCity: selectedArea?.id,
                                onChanged: (value) {
                                  setState(() {
                                    selectedArea = value;
                                  });
                                })
                          ],
                        ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      CommonHelper().labelCommon('Alamat Anda'),
                      TextareaField(
                        hintText: 'Alamat',
                        notesController: addressController,
                      ),
                    ],
                  ),

                  //About
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      CommonHelper().labelCommon('Tentang'),
                      TextareaField(
                        hintText: 'Tentang',
                        notesController: aboutController,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  CommonHelper().buttonOrange('Simpan', () async {
                    if (selectedCity == null || selectedArea == null) {
                      FormHelper.showSnackbar(context,
                          data: 'Mohon memilih kota dan Area',
                          colors: Colors.orange);
                    } else if (isloading == false) {
                      if (addressController.text.isEmpty) {
                        FormHelper.showSnackbar(context,
                            data: 'Mohon mengisi alamat',
                            colors: Colors.orange);
                      } else if (phoneController.text.isEmpty) {
                        FormHelper.showSnackbar(context,
                            data: 'Mohon mengisi nomor handphone',
                            colors: Colors.orange);
                      } else {
                        setState(() {
                          isloading = true;
                        });

                        AuthService.updateProfile(context,
                                name: fullNameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                cityId: selectedCity!.id.toString(),
                                areaId: selectedArea!.id.toString(),
                                postalCode: postCodeController.text,
                                address: addressController.text,
                                selectedFile: pickedImage == null
                                    ? null
                                    : File(pickedImage!.path),
                                about: aboutController.text)
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          if (value.status == RequestStatus.successRequest) {
                            UserState userState =
                                BlocProvider.of<UserCubit>(context).state;
                            if (userState is UserLogged) {
                              BlocProvider.of<ProfileCubit>(context)
                                  .fetchProfile(context,
                                      token: userState.user.token);
                            }
                            FormHelper.showSnackbar(context,
                                data: 'Berhasil merubah profil',
                                colors: Colors.green);
                            Navigator.pop(context);
                          } else {
                            FormHelper.showSnackbar(context,
                                data: value.data ?? 'Gagal merubah profil',
                                colors: Colors.orange);
                          }
                        });
                      }
                      //   if (addressController.text.isEmpty) {
                      //     OthersHelper().showToast(
                      //         asProvider.getString('Address field is required'),
                      //         Colors.black);
                      //     return;
                      //   } else if (phoneController.text.isEmpty) {
                      //     OthersHelper().showToast(
                      //         asProvider.getString('Phone field is required'),
                      //         Colors.black);
                      //     return;
                      //   }

                      //   //update profile
                      //   var result = await provider.updateProfile(
                      //     fullNameController.text,
                      //     emailController.text,
                      //     phoneController.text,
                      //     selectedStateId,
                      //     selectedAreaId,
                      //     Provider.of<CountryStatesService>(context,
                      //             listen: false)
                      //         .selectedCountryId,
                      //     postCodeController.text,
                      //     addressController.text,
                      //     aboutController.text,
                      //     pickedImage?.path,
                      //     context,
                      //   );
                      //   if (result == true || result == false) {
                      //     localAnimationController.reverse();

                    }
                  }, isloading: isloading),

                  const SizedBox(
                    height: 38,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
