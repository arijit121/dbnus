class CustomNotificationModel {
  String? title;
  String? message;
  String? bigText;
  String? imageUrl;
  String? actionURL;
  String? sound;

  CustomNotificationModel(
      {this.title,
      this.message,
      this.bigText,
      this.imageUrl,
      this.actionURL,
      this.sound});

  CustomNotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    message = json['Message'];
    bigText = json['BigText'];
    imageUrl = json['ImageUrl'];
    actionURL = json['ActionURL'];
    sound = json['Sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['Message'] = message;
    data['BigText'] = bigText;
    data['ImageUrl'] = imageUrl;
    data['ActionURL'] = actionURL;
    data['Sound'] = sound;
    return data;
  }
}
