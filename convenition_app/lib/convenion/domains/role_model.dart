import 'user_role_model.dart';

class RoleModel {
  final int? roleId;
  final String? name;
  final String? description;
  final List<UserRoleModel>? userRoles;

  RoleModel({this.roleId, this.name, this.description, this.userRoles});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      roleId: json['roleId'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      userRoles:
          (json['userRoles'] as List<dynamic>?)
              ?.map((e) => UserRoleModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'name': name,
      'description': description,
      'userRoles': userRoles?.map((e) => e.toJson()).toList(),
    };
  }
}
