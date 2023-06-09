class NotificationModel {
  String id;
  String body;
  String modelType;
  String modelId;
  String seen;
  String createdAt;

  NotificationModel({
    required this.id,
    required this.body,
    required this.modelType,
    required this.createdAt,
    required this.modelId,
    required this.seen,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"].toString(),
        body: json["body"].toString(),
        modelId: json["model_id"].toString(),
        modelType: json["model_type"].toString(),
        seen: json["seen"].toString(),
        createdAt: json["created_at"].toString(),
      );
}
