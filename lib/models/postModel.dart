class PostModel {
  dynamic id;
  String title;
  String description;
  String image;

  PostModel(
      {this.id,
      required this.title,
      required this.description,
      required this.image});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
    );
  }
}
