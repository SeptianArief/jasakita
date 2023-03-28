class Area {
  late int id;
  late String area;

  Area({required this.id, required this.area});

  Area.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    area = jsonMap['service_area'];
  }
}
