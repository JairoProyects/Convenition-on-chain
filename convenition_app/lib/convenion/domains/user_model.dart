import 'user_role_model.dart';

enum UserStatus {
  activo,
  inactivo,
  bloqueado,
  unknown; // Added for deserialization robustness

  static UserStatus fromString(String? statusString) {
    if (statusString == null) return UserStatus.unknown;
    try {
      return UserStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == statusString.toLowerCase(),
      );
    } catch (e) {
      return UserStatus.unknown;
    }
  }

  String toJson() => name;
}

class UserModel {
  final int? userId;
  final String? username;
  final String? email;
  final String? passwordHash;
  final String? firstName;
  final String? lastName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserStatus? status;
  final List<UserRoleModel>? userRoles;

  UserModel({
    this.userId,
    this.username,
    this.email,
    this.passwordHash,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.userRoles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      passwordHash: json['passwordHash'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.tryParse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.tryParse(json['updatedAt'] as String),
      status:
          json['status'] == null
              ? null
              : UserStatus.fromString(json['status'] as String?),
      userRoles:
          (json['userRoles'] as List<dynamic>?)
              ?.map((e) => UserRoleModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'firstName': firstName,
      'lastName': lastName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status?.toJson(),
      'userRoles': userRoles?.map((e) => e.toJson()).toList(),
    };
  }
}
