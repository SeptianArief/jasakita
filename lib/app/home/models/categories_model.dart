class Categories {
  late int id;
  late String name;
  late String icon;
  late String? mobileIcon;

  Categories(
      {required this.id,
      required this.name,
      required this.icon,
      this.mobileIcon});

  Categories.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    name = jsonMap['name'];
    icon = jsonMap['icon'];
    mobileIcon = jsonMap['mobile_icon'];
  }
}
