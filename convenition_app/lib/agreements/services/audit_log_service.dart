import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/audit_log_model.dart';
import '../domains/user_model.dart'; // For RecordEventRequest

class AuditLogService {
  final String _baseUrl = "http://localhost:8080/api/auditlogs";

  // DTO for recordEvent requests
  Map<String, dynamic> _recordEventRequestToJson(
    UserModel user,
    String action,
    String resourceType,
    String resourceId,
    String? details,
  ) {
    return {
      'user': user.toJson(), // Assuming user is not null
      'action': action,
      'resourceType': resourceType,
      'resourceId': resourceId,
      'details': details,
    };
  }

  Future<void> recordEvent(
    UserModel user,
    String action,
    String resourceType,
    String resourceId, {
    String? details,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/record'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        _recordEventRequestToJson(
          user,
          action,
          resourceType,
          resourceId,
          details,
        ),
      ),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to record event. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  // For find methods, Spring Pageable translates to query params like page, size, sort.
  // These methods are simplified to not include pagination/sorting parameters for now.
  // They will return a List instead of a Page.

  Future<List<AuditLogModel>> findByActor(String actor) async {
    final response = await http.get(Uri.parse('$_baseUrl/actor?actor=\$actor'));
    if (response.statusCode == 200) {
      // Assuming the backend returns a list of AuditLog items, not a Page object for simplicity
      List<dynamic> body = jsonDecode(response.body);
      // If backend returns Page object, parsing will be: jsonDecode(response.body)['content']
      return body
          .map(
            (dynamic item) =>
                AuditLogModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to find audit logs by actor \$actor. Status: \${response.statusCode}',
      );
    }
  }

  Future<List<AuditLogModel>> findByAction(String action) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/action?action=\$action'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                AuditLogModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to find audit logs by action \$action. Status: \${response.statusCode}',
      );
    }
  }

  Future<List<AuditLogModel>> findByResourceTypeAndResourceId(
    String resourceType,
    String resourceId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/resource?resourceType=\$resourceType&resourceId=\$resourceId',
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                AuditLogModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to find audit logs by resource. Status: \${response.statusCode}',
      );
    }
  }

  Future<List<AuditLogModel>> findByTimestampBetween(
    DateTime startTime,
    DateTime endTime,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/timestamp?startTime=\${startTime.toIso8601String()}&endTime=\${endTime.toIso8601String()}',
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                AuditLogModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to find audit logs by timestamp. Status: \${response.statusCode}',
      );
    }
  }
}
