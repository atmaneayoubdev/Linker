class PlanModel {
  String id;
  String name;
  String price;
  String days;
  List<String> information;

  PlanModel({
    required this.id,
    required this.days,
    required this.price,
    required this.information,
    required this.name,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
        price: json["price"].toString(),
        days: json["days"].toString(),
        information: (json['information'] as List<dynamic>).cast<String>(),
      );
}
