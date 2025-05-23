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
    } catch (_) {
      return UserStatus.unknown;
    }
  }

  String toJson() => name;
}

class UserModel {
  final int?            id;               // JSON key "id"
  final String?         username;
  final String?         email;
  final String?         firstName;
  final String?         lastName;
  final UserStatus?     status;
  final String?         profileImageUrl;  // nuevo campo

  // Opcionales
  final String?             passwordHash;
  final DateTime?           createdAt;
  final DateTime?           updatedAt;
  final List<UserRoleModel>? userRoles;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.status,
    this.profileImageUrl,
    this.passwordHash,
    this.createdAt,
    this.updatedAt,
    this.userRoles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:              json['id']               as int?,
      username:        json['username']         as String?,
      email:           json['email']            as String?,
      firstName:       json['firstName']        as String?,
      lastName:        json['lastName']         as String?,
      status:          UserStatus.fromString(json['status'] as String?),
      profileImageUrl: json['profileImageUrl']  as String?,
      passwordHash:    json['passwordHash']     as String?,
      createdAt:       json['createdAt'] != null
                          ? DateTime.tryParse(json['createdAt'] as String)
                          : null,
      updatedAt:       json['updatedAt'] != null
                          ? DateTime.tryParse(json['updatedAt'] as String)
                          : null,
      userRoles: (json['userRoles'] as List<dynamic>?)
          ?.map((e) => UserRoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':              id,
      'username':        username,
      'email':           email,
      'firstName':       firstName,
      'lastName':        lastName,
      'status':          status?.toJson(),
      'profileImageUrl': profileImageUrl,
      'passwordHash':    passwordHash,
      'createdAt':       createdAt?.toIso8601String(),
      'updatedAt':       updatedAt?.toIso8601String(),
      'userRoles':       userRoles?.map((e) => e.toJson()).toList(),
    };
  }
    UserModel copyWith({
    int?            id,
    String?         username,
    String?         email,
    String?         firstName,
    String?         lastName,
    UserStatus?     status,
    String?         profileImageUrl,
    String?         passwordHash,
    DateTime?       createdAt,
    DateTime?       updatedAt,
    List<UserRoleModel>? userRoles,
  }) {
    return UserModel(
      id:              id               ?? this.id,
      username:        username         ?? this.username,
      email:           email            ?? this.email,
      firstName:       firstName        ?? this.firstName,
      lastName:        lastName         ?? this.lastName,
      status:          status           ?? this.status,
      profileImageUrl: profileImageUrl  ?? this.profileImageUrl,
      passwordHash:    passwordHash     ?? this.passwordHash,
      createdAt:       createdAt        ?? this.createdAt,
      updatedAt:       updatedAt        ?? this.updatedAt,
      userRoles:       userRoles        ?? this.userRoles,
    );
  }
}

// DTO para creación de usuario
class CreateUserDto {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  CreateUserDto({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'username':  username,
        'email':     email,
        'password':  password,
        'firstName': firstName,
        'lastName':  lastName,
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
        'lastName':  lastName,
        'status':    status,
      };
}
