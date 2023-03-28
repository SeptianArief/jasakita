import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/app/auth/service/auth_service.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_cubit.dart';
import 'package:qixer/app/home/cubits/service_cubit/service_state.dart';
import 'package:qixer/app/landing/pages/landing_page.dart';
import 'package:qixer/app/order/cubits/order_cubit.dart';
import 'package:qixer/app/order/cubits/order_state.dart';
import 'package:qixer/app/order/pages/payment_webview_page.dart';
import 'package:qixer/app/order/service/order_service.dart';
import 'package:qixer/shared/cubits/area_master/area_cubit.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/city_master/city_cubit.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/cubits/city_master/city_state.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderVM extends BaseViewModel {
  ServiceCubit serviceCubit = ServiceCubit();
  String? selectedBrand;
  int currentIndex = 1;
  int totalIndex = 5;
  int selectedShedule = 0;
  late String selectedWeekday;
  late String monthAndDate;
  bool isPanelOpened = false;
  var _selectedTime;
  OrderCubit scheduleCubit = OrderCubit();
  AreaCubit areaCubit = AreaCubit();
  City? selectedCity;
  Area? selectedArea;
  String? discountAmount;
  String? discountCode;
  bool couponLoading = false;
  bool paymentLoading = false;

  List<int> selectedExtra = [];

  List<List<String>> dataTitleSubtitle = [
    ["Personalisasi Layanan", 'Selanjutnya : Pilih Jadwal'],
    ["Pilih Jadwal", 'Selanjutnya : Pilih Lokasi'],
    ["Pilih Lokasi", 'Selanjutnya : Informasi'],
    ["Informasi", 'Selanjutnya : Konfirmasi Pesanan'],
    ["Konfirmasi Pesanan", '']
  ];

  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  onExtraTap(int id) {
    if (selectedExtra.contains(id)) {
      selectedExtra.remove(id);
    } else {
      selectedExtra.add(id);
    }
    notifyListeners();
  }

  bool isExtraSelected(int id) {
    if (selectedExtra.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  addExtraQty(int index) {
    ServiceState state = serviceCubit.state;
    if (state is ServiceBookingLoaded) {
      state.data.serviceAdditional[index]['additional_service_quantity'] =
          (int.parse(state.data
                      .serviceAdditional[index]['additional_service_quantity']
                      .toString()) +
                  1)
              .toString();

      serviceCubit.updateBookingState(state.data);
    }
  }

  decExtraQty(int index) {
    ServiceState state = serviceCubit.state;
    if (state is ServiceBookingLoaded) {
      if (int.parse(state
              .data.serviceAdditional[index]['additional_service_quantity']
              .toString()) >
          1) {
        state.data.serviceAdditional[index]['additional_service_quantity'] =
            (int.parse(state.data
                        .serviceAdditional[index]['additional_service_quantity']
                        .toString()) -
                    1)
                .toString();

        serviceCubit.updateBookingState(state.data);
      }
    }
  }

  setBrands(String val) {
    selectedBrand = val;
    notifyListeners();
  }

  onQtyAdded(int index) {
    ServiceState state = serviceCubit.state;
    if (state is ServiceBookingLoaded) {
      state.data.serviceIncluded[index]['include_service_quantity'] =
          (int.parse(state
                      .data.serviceIncluded[index]['include_service_quantity']
                      .toString()) +
                  1)
              .toString();

      serviceCubit.updateBookingState(state.data);
    }
  }

  onQtyDec(int index) {
    ServiceState state = serviceCubit.state;
    if (state is ServiceBookingLoaded) {
      if (int.parse(state
              .data.serviceIncluded[index]['include_service_quantity']
              .toString()) >
          1) {
        state.data.serviceIncluded[index]['include_service_quantity'] =
            (int.parse(state
                        .data.serviceIncluded[index]['include_service_quantity']
                        .toString()) -
                    1)
                .toString();

        serviceCubit.updateBookingState(state.data);
      }
    }
  }

  firstThreeLetter(value) {
    var weekDayName = DateFormat('EEEE').format(value).toString();
    return weekDayName.substring(0, 3);
  }

  getMonthAndDate(value) {
    final f = DateFormat("MMMM dd");
    var d = f.format(value);
    return d;
  }

  onInit(BuildContext context, {required String id}) {
    serviceCubit.fetchDetailBookingService(context, id: id);
    selectedWeekday = firstThreeLetter(DateTime.now());
    monthAndDate = getMonthAndDate(DateTime.now());
    ProfileState profileState = BlocProvider.of<ProfileCubit>(context).state;

    if (profileState is ProfileLoaded) {
      userNameController.text = profileState.data.detail.name;
      emailController.text = profileState.data.detail.email;
      phoneController.text = profileState.data.detail.phone;
      postCodeController.text = profileState.data.detail.postalCode;
      addressController.text = profileState.data.detail.address;
    }
  }

  onChangeDate(DateTime data) {
    selectedWeekday = firstThreeLetter(data);
    monthAndDate = getMonthAndDate(data);
    notifyListeners();
  }

  onScheduleReload(BuildContext context) {
    ServiceState state = serviceCubit.state;
    if (state is ServiceBookingLoaded) {
      scheduleCubit.fetchSchedule(context,
          day: selectedWeekday,
          sellerId: state.data.sellerId, onSucess: (value) {
        selectedShedule = 0;
      });
    }
  }

  onChangeScheduleIndex(int value) {
    selectedShedule = value;
    notifyListeners();
  }

  onLocationInit(BuildContext context) {
    ProfileState state = BlocProvider.of<ProfileCubit>(context).state;
    if (state is ProfileLoaded) {
      selectedCity = state.data.detail.city;
      areaCubit.fetchArea(context,
          idCity: state.data.detail.city.id.toString());
      selectedArea = state.data.detail.area;
      notifyListeners();
    }
  }

  onChangeArea(Area data) {
    selectedArea = data;
    notifyListeners();
  }

  onCityChanged(BuildContext context, City data) {
    selectedCity = data;
    areaCubit.fetchArea(context, idCity: data.id.toString());
    selectedArea = null;
    notifyListeners();
  }

  double getTotalPrice() {
    ServiceState serviceState = serviceCubit.state;
    double totalPrice = 0;
    if (serviceState is ServiceBookingLoaded) {
      serviceState.data.serviceIncluded.forEach((element) {
        totalPrice = totalPrice +
            (int.parse(element['include_service_quantity'].toString()) *
                double.parse(element['include_service_price']));
      });
    }

    return totalPrice;
  }

  panelChanged(bool value) {
    isPanelOpened = value;
    notifyListeners();
  }

  double getExtraCharge() {
    ServiceState state = serviceCubit.state;
    double totalPrice = 0;
    if (state is ServiceBookingLoaded) {
      state.data.serviceAdditional.forEach((element) {
        if (selectedExtra.contains(element['id'])) {
          totalPrice = totalPrice +
              (int.parse(element['additional_service_quantity']) *
                  double.parse(element['additional_service_price']));
        }
      });
    }

    return totalPrice;
  }

  double getTaxCharge() {
    ServiceState state = serviceCubit.state;
    double totalPrice = 0;
    if (state is ServiceBookingLoaded) {
      double tax = double.parse(state.data.tax);
      totalPrice = (tax / 100) * (getExtraCharge() + getTotalPrice());
    }

    return totalPrice;
  }

  double getDiscount() {
    if (discountAmount == null) {
      return 0;
    } else {
      return double.parse(discountAmount!);
    }
  }

  applyCoupon(BuildContext context,
      {required String coupon, required Function onCallback}) {
    couponLoading = true;
    notifyListeners();
    onCallback();
    ServiceState state = serviceCubit.state;
    if (state is ServiceBookingLoaded) {
      OrderService.applyCoupon(context,
              coupon: coupon,
              totalAmount: (getTaxCharge() + getTotalPrice() + getExtraCharge())
                  .toStringAsFixed(0),
              sellerId: state.data.sellerId)
          .then((value) {
        couponLoading = false;
        notifyListeners();
        onCallback();
        if (value.status == RequestStatus.successRequest) {
          discountAmount = value.data;
          discountCode = coupon;
          FormHelper.showSnackbar(context,
              data: 'Berhasil menerapkan kupon', colors: Colors.green);
        } else {
          FormHelper.showSnackbar(context,
              data: value.data ?? 'Gagal cek kupon', colors: Colors.orange);
        }
      });
    }
  }

  payment(
    BuildContext context, {
    required Function onCallback,
  }) {
    paymentLoading = true;
    notifyListeners();
    onCallback();
    ServiceState state = serviceCubit.state;
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    OrderState scheduleState = scheduleCubit.state;
    if (state is ServiceBookingLoaded &&
        userState is UserLogged &&
        scheduleState is ScheduleLoaded) {
      OrderService.bookingService(context,
              sellerId: state.data.sellerId,
              buyerId: userState.user.id,
              included: state.data.serviceIncluded,
              extras: state.data.serviceAdditional,
              selectedExtra: selectedExtra,
              serviceId: state.data.id.toString(),
              name: userNameController.text,
              phone: phoneController.text,
              email: emailController.text,
              postCode: postCodeController.text,
              address: addressController.text,
              selectedDate: monthAndDate,
              selectedSchedule: scheduleState.data[selectedShedule],
              coupon: discountCode ?? '',
              selectedBrand: selectedBrand,
              notes: notesController.text)
          .then((value) {
        ProfileState stateProfile =
            BlocProvider.of<ProfileCubit>(context).state;
        if (stateProfile is ProfileLoaded) {
          AuthService.updateProfile(context,
              name: userNameController.text,
              email: emailController.text,
              phone: phoneController.text,
              cityId: selectedCity!.id.toString(),
              areaId: selectedArea!.id.toString(),
              postalCode: postCodeController.text,
              address: addressController.text,
              about: stateProfile.data.detail.about ?? '');

          // PushNotificationService().sendNotificationToSeller(context,
          //     sellerId: int.parse(state.data.sellerId),
          //     title:
          //         "Anda mendapatkan pesanan dari ${stateProfile.data.detail.name}",
          //     body: '-');
        }
        paymentLoading = false;
        notifyListeners();
        if (value.status == RequestStatus.successRequest) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const LandingPage(
                        initialPage: 1,
                      )));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => UserPaymentWebview(
                        url: value.data,
                        isFromOrder: true,
                        extraCharge: getExtraCharge(),
                        jadwal: scheduleState.data[selectedShedule],
                        subtotal: getTotalPrice() + getExtraCharge(),
                        tanggal: monthAndDate,
                        tax: state.data.tax,
                        taxPrice: getTaxCharge(),
                        total: getTotalPrice() +
                            getExtraCharge() +
                            getTaxCharge() -
                            getDiscount(),
                        totalPackage: getTotalPrice(),
                      )));
        } else {
          FormHelper.showSnackbar(context,
              data: 'Gagal melakukan request pembayaran',
              colors: Colors.orange);
        }
      });
    }
  }
}
