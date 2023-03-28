import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';

class ProfileModel {
  late int pendingOrder;
  late int activeOrder;
  late int completeOrder;
  late int totalOrder;

  late ProfileDetail detail;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    pendingOrder = json["pending_order"];
    activeOrder = json["active_order"];
    completeOrder = json["complete_order"];
    totalOrder = json["total_order"];
    String? profileUrl;

    try {
      profileUrl = json["profile_image"]['img_url'];
    } catch (e) {}

    detail = ProfileDetail.fromJson(json['user_details'], profileUrl);
  }
}

class ProfileDetail {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String address;
  late String? about;
  late int countryId;
  late String serviceCity;
  late String serviceArea;
  late String postalCode;
  late String? image;
  late String countryCode;
  late City city;
  late Area area;

  ProfileDetail.fromJson(Map<String, dynamic> json, String? profile) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    address = json["address"] ?? '';
    about = json["about"];
    countryId = json["country_id"] == null ? 1 : int.parse(json["country_id"]);
    serviceCity = json["service_city"];
    serviceArea = json["service_area"];
    postalCode = json["post_code"] ?? '';
    image = profile;
    countryCode = json["country_code"];
    city = City.formJson(json["city"]);
    area = Area.fromJson(json["area"]);
  }
}
