import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/notification_model.dart';
import '../domains/user_model.dart'; // For CreateNotificationWithUserRequest

class NotificationService {
  final String _baseUrl = "http://localhost:8080/api/notifications";

  // DTO for createNotification requests (matching controller DTO)
  Map<String, dynamic> _createNotificationRequestToJson(
    UserModel? user,
    int? userId,
    String message,
    String type,
    String link,
  ) {
    return {
      'user': user?.toJson(),
      'userId': userId,
      'message': message,
      'type': type,
      'link': link,
    };
  }

  Map<String, dynamic> _markAsReadRequestToJson(List<int> notificationIds) {
    return {'notificationIds': notificationIds};
  }

  Future<NotificationModel> createNotificationWithUser(
    UserModel user,
    String message,
    String type,
    String link,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        _createNotificationRequestToJson(user, null, message, type, link),
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NotificationModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to create notification with user. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<NotificationModel> createNotificationWithUserId(
    int userId,
    String message,
    String type,
    String link,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/userid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        _createNotificationRequestToJson(null, userId, message, type, link),
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NotificationModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to create notification with userId. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<List<NotificationModel>> getUnreadNotifications(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/unread/\$userId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load unread notifications for user \$userId. Status: \${response.statusCode}',
      );
    }
  }

  Future<List<NotificationModel>> getAllNotificationsForUser(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/all/\$userId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                NotificationModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load all notifications for user \$userId. Status: \${response.statusCode}',
      );
    }
  }

  Future<void> markNotificationsAsRead(
    int userId,
    List<int> notificationIds,
  ) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/read/\$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(_markAsReadRequestToJson(notificationIds)),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to mark notifications as read. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<void> markAllNotificationsAsRead(int userId) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/read/all/\$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to mark all notifications as read. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }
}
