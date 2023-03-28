class City {
  late int id;
  late String serviceCity;

  City({required this.id, required this.serviceCity});

  City.formJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    try {
      serviceCity = jsonMap['service_city'];
    } catch (e) {
      serviceCity = jsonMap['name'];
    }
  }
}
