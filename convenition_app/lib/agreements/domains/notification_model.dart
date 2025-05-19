import 'user_model.dart';

class NotificationModel {
  final int? id;
  final UserModel? user;
  final String? message;
  final String? type;
  final bool? isRead;
  final DateTime? createdAt;
  final String? link;

  NotificationModel({
    this.id,
    this.user,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.link,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String?,
      type: json['type'] as String?,
      isRead: json['isRead'] as bool?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.tryParse(json['createdAt'] as String),
      link: json['link'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'link': link,
    };
  }
}
