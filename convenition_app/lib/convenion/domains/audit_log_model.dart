import 'user_model.dart';

class AuditLogModel {
  final int? id;
  final UserModel? user;
  final String? action;
  final String? resourceType;
  final String? resourceId;
  final DateTime? timestamp;
  final String? details;

  AuditLogModel({
    this.id,
    this.user,
    this.action,
    this.resourceType,
    this.resourceId,
    this.timestamp,
    this.details,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] as int?,
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      action: json['action'] as String?,
      resourceType: json['resourceType'] as String?,
      resourceId: json['resourceId'] as String?,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.tryParse(json['timestamp'] as String),
      details: json['details'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'action': action,
      'resourceType': resourceType,
      'resourceId': resourceId,
      'timestamp': timestamp?.toIso8601String(),
      'details': details,
    };
  }
}
