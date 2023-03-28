import 'package:qixer/app/home/models/service_model.dart';

class OrderDetailModel {
  late String paymentUrl;
  late int hasReport;
  late SellerModel seller;
  late OrderDetailData data;

  OrderDetailModel.fromJson(Map<String, dynamic> jsonMap) {
    paymentUrl = jsonMap['payment_redirect_url'] ?? '';
    hasReport = jsonMap['orderInfo']['has_report'] ?? 0;
    seller = SellerModel.fromJson(jsonMap['orderInfo']['seller']);
    data = OrderDetailData.fromJson(jsonMap['orderInfo']);
  }
}

class OrderDetailData {
  late int id;
  late String serviceId;
  late String sellerId;
  late String buyerId;
  late String name;
  late String email;
  late String phone;
  late String postCode;
  late String address;
  late String? city;
  late String? area;
  late String date;
  late String scheulde;
  late String packageFee;
  late String extraService;
  late String subTotal;
  late String tax;
  late String total;
  late String? couponCode;
  late String couponAmount;
  late String paymentStatus;
  late int status;
  late String? brands;
  late String? orderNote;
  late String? orderFromJob;
  late String createdAt;
  late String? paymentGateway;
  late int orderCompleteRequest;

  OrderDetailData.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    serviceId = jsonMap['service_id'];
    sellerId = jsonMap['seller_id'];
    buyerId = jsonMap['buyer_id'];
    name = jsonMap['name'];
    email = jsonMap['email'];
    phone = jsonMap['phone'];
    postCode = jsonMap['post_code'];
    address = jsonMap['address'];
    city = jsonMap['city'];
    area = jsonMap['area'];
    date = jsonMap['date'];
    scheulde = jsonMap['schedule'];
    packageFee = jsonMap['package_fee'];
    extraService = jsonMap['extra_service'];
    subTotal = jsonMap['sub_total'];
    tax = jsonMap['tax'];
    total = jsonMap['total'];
    couponCode = jsonMap['coupon_code'];
    couponAmount = jsonMap['coupon_amount'];
    paymentStatus = jsonMap['payment_status'];
    status = jsonMap['status'];
    brands = jsonMap['brands'];
    orderNote = jsonMap['order_note'];
    orderFromJob = jsonMap['order_from_job'];
    createdAt = jsonMap['created_at'];
    paymentGateway = jsonMap['payment_gateway'];
    orderCompleteRequest = int.parse(jsonMap['order_complete_request']);
  }
}

class OrderPreview {
  late int id;
  late String total;
  late String serviceName;
  late String sellerId;
  late String buyerId;
  late String? brandName;
  late String? notes;
  late String date;
  late String schedule;
  late int status;
  late String paymentStatus;

  OrderPreview.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    total = jsonMap['total'];
    serviceName = jsonMap['service_name'];
    sellerId = jsonMap['seller_id'];
    buyerId = jsonMap['buyer_id'];
    brandName = jsonMap['brands'];
    notes = jsonMap['order_note'];
    date = jsonMap['date'];
    schedule = jsonMap['schedule'];
    paymentStatus = jsonMap['payment_status'];
    status = jsonMap['status'];
  }
}
