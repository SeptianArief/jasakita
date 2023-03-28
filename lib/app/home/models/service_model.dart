import 'dart:developer';

import 'package:qixer/shared/const_helper.dart';

class ServiceBookingModel {
  late int id;
  late String sellerId;
  late String title;
  late String price;
  late String tax;
  late String imageUrl;
  late String isOnline;
  late String serviceCity;
  late List<dynamic> serviceAdditional = [];
  late List<dynamic> serviceIncluded = [];
  late List<dynamic> serviceBenefits = [];

  ServiceBookingModel.fromJson(Map<String, dynamic> jsonMap) {
    Map<String, dynamic> jsonMapService = jsonMap['service'];
    id = jsonMapService['id'];
    sellerId = jsonMapService['seller_id'];
    title = jsonMapService['title'];
    price = jsonMapService['price'];
    tax = jsonMapService['tax'];
    isOnline = jsonMapService['is_service_online'];
    serviceCity = jsonMapService['service_city_id'];
    serviceAdditional = jsonMapService['service_additional'];
    serviceIncluded = jsonMapService['service_include'];
    serviceBenefits = jsonMapService['service_benifit'];

    // bool foundImage = false;
    // jsonMap['service_image'].forEach((element) {
    //   try {
    //     if (element['image_id'] == jsonMapService['image']) {
    //       imageUrl = element['img_url'];
    //       foundImage = true;
    //     }
    //   } catch (e) {}
    // });

    // if (!foundImage) {
    //   imageUrl = placeHolderUrl;
    // }

    imageUrl = jsonMap['service_image'][1]['img_url'];
  }
}

class ServiceDetail {
  late int id;
  late String categoryId;
  late String sellerId;
  late String title;
  late String description;
  late String image;
  late int status;
  late String isStatusOn;
  late String price;
  late String isOnline;
  late String onlinePrice;
  late String tax;
  late String deliveryTime;
  late String view;
  late String soldCount;
  late String serviceAreaName;
  late String serviceCityName;
  late List<dynamic> brands = [];
  late List<dynamic> faq = [];
  late String nameSeller;
  late String imageSeller;
  late List<dynamic> reviewsForMobile = [];
  late int completeOrder;
  late List<dynamic> includedService = [];
  late List<dynamic> benefitsService = [];
  late String completeRate;
  late String memberSince;

  ServiceDetail.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['service_details']['id'];
    categoryId = jsonMap['service_details']['category_id'];
    sellerId = jsonMap['service_details']['seller_id'];
    title = jsonMap['service_details']['title'];
    description = jsonMap['service_details']['description'];
    image = jsonMap['service_image']['img_url'];
    status = jsonMap['service_details']['status'];

    isStatusOn = jsonMap['service_details']['is_service_on'];
    price = jsonMap['service_details']['price'];
    isOnline = jsonMap['service_details']['is_service_online'];
    onlinePrice = jsonMap['service_details']['online_service_price'];
    tax = jsonMap['service_details']['tax'];
    deliveryTime = jsonMap['service_details']['delivery_days'];
    view = jsonMap['service_details']['view'];
    soldCount = jsonMap['service_details']['sold_count'];
    serviceAreaName = jsonMap['service_details']['service_area_name'];
    serviceCityName = jsonMap['service_details']['service_city_name'];
    brands = jsonMap['service_brands'];
    faq = jsonMap['service_details']['service_faq'];
    nameSeller = jsonMap['service_seller_name'];
    try {
      imageSeller = jsonMap['service_seller_image']['img_url'];
    } catch (e) {
      imageSeller = placeHolderUrl;
    }
    reviewsForMobile = jsonMap['service_reviews'];
    completeOrder = jsonMap['seller_complete_order'];
    includedService = jsonMap['service_includes'];
    benefitsService = jsonMap['service_benifits'];
    completeRate = jsonMap['order_completion_rate'].toString();
    memberSince = jsonMap['seller_since']['created_at'];
  }
}

class ServiceGrouping {
  late int id;
  late String name;
  List<ServiceModel> data = [];

  ServiceGrouping.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    data = List.generate(jsonMap['services'].length, (index) {
      return ServiceModel.fromJson(jsonMap['services'][index]);
    });
  }
}

class ServiceModel {
  late int id;
  late String categoryId;
  late String sellerId;
  late String serviceCityId;
  late String title;
  late String slug;
  late String desc;
  late String image;
  late int status;
  late String isServiceOn;
  late String price;
  late String areaName;
  late String cityName;
  late String reviewSummary;
  late SellerModel? seller;
  late List<dynamic> dataReview = [];

  ServiceModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    categoryId = jsonMap['category_id'];
    sellerId = jsonMap['seller_id'];
    serviceCityId = jsonMap['service_city_id'];
    title = jsonMap['title'];
    slug = jsonMap['slug'];
    desc = jsonMap['description'];
    image = jsonMap['image']['img_url'];
    status = jsonMap['status'] ?? 1;
    isServiceOn = jsonMap['is_service_on'] ?? '1';
    price = jsonMap['price'];
    areaName = jsonMap['service_area_name'];
    cityName = jsonMap['service_city_name'];
    dataReview = jsonMap['reviews_for_mobile'] ?? [];

    seller = jsonMap['seller'] == null
        ? null
        : SellerModel.fromJson(jsonMap['seller']);

    double ratingTotal = 0;

    dataReview.forEach((element) {
      ratingTotal = ratingTotal + double.parse(element['rating']);
    });

    reviewSummary = ratingTotal == 0
        ? "0.0"
        : (ratingTotal / dataReview.length).toStringAsFixed(1);
  }

  ServiceModel.fromJsonToCategories(
      Map<String, dynamic> jsonMap, List<dynamic> dataImage) {
    id = jsonMap['id'];
    categoryId = '';
    sellerId = jsonMap['seller_id'];
    serviceCityId = jsonMap['service_city_id'];
    title = jsonMap['title'];
    slug = jsonMap['slug'] ?? '';
    desc = jsonMap['description'] ?? '';
    dataImage.forEach((element) {
      if (element['image_id'].toString() == jsonMap['image']) {
        image = element['img_url'];
      }
    });

    status = jsonMap['status'] ?? 1;
    isServiceOn = jsonMap['is_service_on'] ?? '1';
    price = jsonMap['price'];
    areaName = jsonMap['service_area_name'];
    cityName = jsonMap['service_city_name'];
    dataReview = jsonMap['reviews_for_mobile'];
    seller = SellerModel.fromJson(jsonMap['seller']);

    double ratingTotal = 0;

    dataReview.forEach((element) {
      ratingTotal = ratingTotal + double.parse(element['rating']);
    });

    reviewSummary = ratingTotal == 0
        ? "0.0"
        : (ratingTotal / dataReview.length).toStringAsFixed(1);
  }

  ServiceModel.fromJsonToSearch(
      Map<String, dynamic> jsonMap, List<dynamic> dataImage) {
    id = jsonMap['id'];
    categoryId = '';
    sellerId = jsonMap['seller_id'];
    serviceCityId = jsonMap['service_city_id'];
    title = jsonMap['title'];
    slug = jsonMap['slug'] ?? '';
    desc = jsonMap['description'] ?? '';
    dataImage.forEach((element) {
      if (element['image_id'].toString() == jsonMap['image']) {
        image = element['img_url'];
      }
    });

    status = jsonMap['status'] ?? 1;
    isServiceOn = jsonMap['is_service_on'] ?? '1';
    price = jsonMap['price'];
    areaName = jsonMap['service_area_name'];
    cityName = jsonMap['service_city_name'];
    dataReview = jsonMap['reviews_for_mobile'];
    seller = SellerModel.fromJsonToSearch(
        jsonMap['seller'], jsonMap['seller_for_mobile']);

    double ratingTotal = 0;

    dataReview.forEach((element) {
      ratingTotal = ratingTotal + double.parse(element['rating']);
    });

    reviewSummary = ratingTotal == 0
        ? "0.0"
        : (ratingTotal / dataReview.length).toStringAsFixed(1);
  }

  ServiceModel.fromJsonNew(Map<String, dynamic> jsonMap,
      List<dynamic> dataImage, List<dynamic> dataSeller) {
    id = jsonMap['id'];
    categoryId = jsonMap['category_id'];
    sellerId = jsonMap['seller_id'];
    serviceCityId = jsonMap['service_city_id'] ?? "";
    title = jsonMap['title'];
    slug = jsonMap['slug'] ?? '';
    desc = jsonMap['description'] ?? '';
    dataImage.forEach((element) {
      if (element['image_id'].toString() == jsonMap['image']) {
        image = element['img_url'];
      }
    });
    status = jsonMap['status'] ?? 1;
    isServiceOn = jsonMap['is_service_on'] ?? '1';
    price = jsonMap['price'];
    areaName = jsonMap['service_area_name'];
    cityName = jsonMap['service_city_name'];
    dataReview = jsonMap['reviews_for_mobile'];
    seller = SellerModel.fromJsonNew(
        jsonMap['seller_for_mobile'], dataSeller, dataImage);

    double ratingTotal = 0;

    dataReview.forEach((element) {
      ratingTotal = ratingTotal + double.parse(element['rating']);
    });

    reviewSummary = ratingTotal == 0
        ? "0.0"
        : (ratingTotal / dataReview.length).toStringAsFixed(1);
  }
}

class SellerModel {
  late int id;
  late String name;
  late String email;
  late String username;
  late String phone;
  late String image;
  late String address;
  late String about;
  late String? firebaseToken;
  late String cityId;

  SellerModel.fromJsonNew(Map<String, dynamic> jsonMap,
      List<dynamic> dataImageSeller, List<dynamic> imageData) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    email = jsonMap['email'] ?? '';
    username = jsonMap['username'] ?? '';
    phone = jsonMap['phone'] ?? '';
    bool isFound = false;
    dataImageSeller.forEach((element) {
      try {
        if (element['image_id'].toString() == jsonMap['image']) {
          image = element['img_url'];
          isFound = true;
        }
      } catch (e) {}
    });

    imageData.forEach((element) {
      try {
        if (element['image_id'].toString() == jsonMap['image']) {
          image = element['img_url'];
          isFound = true;
        }
      } catch (e) {}
    });

    if (isFound == false) {
      image = placeHolderUrl;
    }

    address = jsonMap['address'] ?? '';
    about = jsonMap['about'] ?? '';
    cityId = jsonMap['service_city'] ?? '';
  }

  SellerModel.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    firebaseToken = jsonMap['cm_firebase_token'];
    email = jsonMap['email'] ?? '';
    username = jsonMap['username'] ?? '';
    phone = jsonMap['phone'] ?? '';
    try {
      image = jsonMap['image']['img_url'];
    } catch (e) {
      image = placeHolderUrl;
    }
    address = jsonMap['address'] ?? '';
    about = jsonMap['about'] ?? '';
    cityId = jsonMap['service_city'] ?? '';
  }

  SellerModel.fromJsonToSearch(
      Map<String, dynamic> jsonMap, Map<String, dynamic> jsonMapMobile) {
    id = jsonMapMobile['id'];
    name = jsonMapMobile['name'];
    email = jsonMap['email'] ?? '';
    username = jsonMap['username'] ?? '';
    phone = jsonMap['phone'] ?? '';
    try {
      image = jsonMap['image']['img_url'];
    } catch (e) {
      image = placeHolderUrl;
    }
    address = jsonMap['address'] ?? '';
    about = jsonMap['about'] ?? '';
    cityId = jsonMap['service_city'] ?? '';
  }
}
