class PageModel {
  String id;
  String name;
  String content;

  PageModel({
    required this.id,
    required this.name,
    required this.content,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
        content: json["content"].toString(),
      );
}
