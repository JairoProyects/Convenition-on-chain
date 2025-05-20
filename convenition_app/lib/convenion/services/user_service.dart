import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/user_model.dart';
import '../../shared/config/api_config.dart';

class UserService {
  final String _baseUrl = ApiConfig.users;

  Future<UserModel> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$_baseUrl/\$email'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load user with email \$email. Status: \${response.statusCode}',
      );
    }
  }
}
