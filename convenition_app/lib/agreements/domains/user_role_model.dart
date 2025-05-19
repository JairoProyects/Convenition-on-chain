import 'user_model.dart';
import 'role_model.dart';

class UserRoleIdModel {
  final int? userId;
  final int? roleId;

  UserRoleIdModel({this.userId, this.roleId});

  factory UserRoleIdModel.fromJson(Map<String, dynamic> json) {
    return UserRoleIdModel(
      userId: json['userId'] as int?,
      roleId: json['roleId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'roleId': roleId};
  }
}

class UserRoleModel {
  final UserRoleIdModel? id;
  final UserModel? user;
  final RoleModel? role;
  final DateTime? assignedAt;

  UserRoleModel({this.id, this.user, this.role, this.assignedAt});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id:
          json['id'] == null
              ? null
              : UserRoleIdModel.fromJson(json['id'] as Map<String, dynamic>),
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      role:
          json['role'] == null
              ? null
              : RoleModel.fromJson(json['role'] as Map<String, dynamic>),
      assignedAt:
          json['assignedAt'] == null
              ? null
              : DateTime.tryParse(json['assignedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toJson(),
      'user': user?.toJson(),
      'role': role?.toJson(),
      'assignedAt': assignedAt?.toIso8601String(),
    };
  }
}
