class FeedbackModel {
  final String id;
  final String parkingAreaName;
  final String title;
  final String description;
  final DateTime createdDate;
  final String sessionId;
  final String isFeedback;

  FeedbackModel({
    required this.id,
    required this.parkingAreaName,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.sessionId,
    required this.isFeedback,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      parkingAreaName: json['parkingAreaName'],
      title: json['title'],
      description: json['description'],
      createdDate: DateTime.parse(json['createdDate']),
      sessionId: json['sessionId'],
      isFeedback: json['isFeedback'],
    );
  }
}

class SendFeedbackModel {
  final String sessionId;
  final String description;
  final String title;

  SendFeedbackModel({
    required this.sessionId,
    required this.description,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'description': description,
      'title': title,
    };
  }
}
