import 'package:qixer/app/home/models/service_model.dart';

class VendorDetail {
  late VendorModelPreview preview;
  late int completeOrder;
  late int serviceRating;
  List<ServiceModel> dataService = [];
  List<dynamic> dataReview = [];

  VendorDetail.fromJson(Map<String, dynamic> jsonMap) {
    preview = VendorModelPreview.fromJson(jsonMap['seller']);
    completeOrder = jsonMap['completed_order'];
    serviceRating = double.parse(jsonMap['service_rating'] ?? '0').toInt();
    for (var i = 0; i < jsonMap['services'].length; i++) {
      dataService.add(ServiceModel.fromJson(jsonMap['services'][i]));
    }

    dataReview = jsonMap['service_reviews'];
  }
}

class VendorModelPreview {
  late int id;
  late String name;
  late String email;
  late String username;
  late String image;
  late String serviceCity;
  late String serviceArea;
  late String cityName;
  late String areaName;
  late double sellerRating;
  late int rating;
  late int completeOrder;

  VendorModelPreview.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    email = jsonMap['email'];
    username = jsonMap['username'];
    image = jsonMap['image']['img_url'];
    serviceCity = jsonMap['service_city'] ?? '';
    serviceArea = jsonMap['service_area'] ?? '';
    cityName = jsonMap['service_city_name'] ?? '';
    areaName = jsonMap['service_area_name'] ?? '';
    sellerRating = double.parse(jsonMap['seller_rating'] ?? '0');
    rating = sellerRating.toInt();
    completeOrder = jsonMap['completed_order'] ?? 0;
  }
}
