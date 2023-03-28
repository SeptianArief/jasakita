class User {
  late String token;
  late String id;
  late String phone;
  late String email;
  late int userType;
  late String countryId;
  late String stateId;
  late String username;

  User.fromJson(Map<String, dynamic> jsonMap) {
    Map<String, dynamic> dataTemp = jsonMap['users'];

    token = jsonMap['token'];
    id = dataTemp['id'].toString();
    phone = dataTemp['phone'];
    email = dataTemp['email'];
    userType = dataTemp['user_type'];
    countryId = dataTemp['country_id'];
    stateId = dataTemp['state'];
    username = dataTemp['username'];
  }
}
