class FcmNotificationModel {
  String? title;
  String? message;
  String? bigText;
  String? imageUrl;
  String? actionURL;

  FcmNotificationModel(
      {this.title, this.message, this.bigText, this.imageUrl, this.actionURL});

  FcmNotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    message = json['Message'];
    bigText = json['BigText'];
    imageUrl = json['ImageUrl'];
    actionURL = json['ActionURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['Message'] = message;
    data['BigText'] = bigText;
    data['ImageUrl'] = imageUrl;
    data['ActionURL'] = actionURL;
    return data;
  }
}
