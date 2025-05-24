import 'user_role_model.dart';

enum UserStatus {
  activo,
  inactivo,
  bloqueado,
  unknown;

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
  final String? identification; // <-- NUEVO
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final UserStatus? status;

  // Campos opcionales
  final String? passwordHash;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserRoleModel>? userRoles;

  UserModel({
    this.userId,
    this.identification, // <-- NUEVO
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.status,
    this.passwordHash,
    this.createdAt,
    this.updatedAt,
    this.userRoles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int?,
      identification: json['identification'] as String?, // <-- NUEVO
      username: json['username'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      status: UserStatus.fromString(json['status'] as String?),
      passwordHash: json['passwordHash'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      userRoles: (json['userRoles'] as List<dynamic>?)
          ?.map((e) => UserRoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'identification': identification, // <-- NUEVO
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'status': status?.toJson(),
      'passwordHash': passwordHash,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'userRoles': userRoles?.map((e) => e.toJson()).toList(),
    };
  }
}

// DTO para creación de usuario
class CreateUserDto {
  final String identification; // <-- NUEVO
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  CreateUserDto({
    required this.identification,
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'identification': identification, // <-- NUEVO
        'username': username,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };
}

// DTO para actualización de usuario
class UpdateUserDto {
  final String firstName;
  final String lastName;
  final String status;

  UpdateUserDto({
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'status': status,
      };
}
