import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/user_model.dart';

class UserService {
  final String _baseUrl = "http://localhost:8080/api/userdetails";

  Future<UserModel> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$_baseUrl/\$email'));

    if (response.statusCode == 200) {
      // Assuming the response body is compatible with UserModel.fromJson
      // The UserDetailsController returns Spring Security's UserDetails, which might differ
      // from the UserModel structure. This may need adjustment on the backend or here.
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
