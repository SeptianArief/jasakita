class SliderModel {
  late String imageUrl;
  late String title;
  late String subtitle;

  SliderModel.formJson(Map<String, dynamic> jsonMap, List<dynamic> dataImage) {
    title = jsonMap['title'];
    subtitle = jsonMap['sub_title'];

    dataImage.forEach((element) {
      if (element['image_id'].toString() == jsonMap['background_image']) {
        imageUrl = element['img_url'];
      }
    });
  }
}
