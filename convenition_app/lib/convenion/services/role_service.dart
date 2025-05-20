import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/role_model.dart';

class RoleService {
  final String _baseUrl = "http://localhost:8080/api/roles"; // Generic endpoint

  Future<List<RoleModel>> fetchRoles() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) => RoleModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to load roles. Status: \${response.statusCode}');
    }
  }

  Future<RoleModel> fetchRoleById(String id) async {
    // Assuming ID is String, adjust if int
    final response = await http.get(Uri.parse('$_baseUrl/\$id'));
    if (response.statusCode == 200) {
      return RoleModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load role \$id. Status: \${response.statusCode}',
      );
    }
  }

  Future<RoleModel> createRole(RoleModel role) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(role.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return RoleModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to create role. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<RoleModel> updateRole(String id, RoleModel role) async {
    // Assuming ID is String
    final response = await http.put(
      Uri.parse('$_baseUrl/\$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(role.toJson()),
    );
    if (response.statusCode == 200) {
      return RoleModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to update role \$id. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<void> deleteRole(String id) async {
    // Assuming ID is String
    final response = await http.delete(Uri.parse('$_baseUrl/\$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete role \$id. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }
}
