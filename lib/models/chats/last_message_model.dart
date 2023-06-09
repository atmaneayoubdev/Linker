class LastMessageModel {
  String sendBy;
  String message;
  String type;
  String seen;

  LastMessageModel({
    required this.sendBy,
    required this.message,
    required this.type,
    required this.seen,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      LastMessageModel(
        sendBy: json["sendBy"].toString(),
        message: json["message"].toString(),
        type: json["type"].toString(),
        seen: json["seen"].toString(),
      );
}
