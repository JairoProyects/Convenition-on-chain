import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../domains/user_model.dart';
import '../../shared/config/api_config.dart';

class UserService {
  final _baseUrlUser = ApiConfig.users;

  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(Uri.parse(_baseUrlUser));
    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users. Status: ${response.statusCode}');
    }
  }

  // GET /users/{id} → obtiene uno por id
  Future<UserModel> getUserById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrlUser/$id'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load user with id $id. Status: ${response.statusCode}',
      );
    }
  }

  // POST /register → crea uno nuevo
  Future<UserModel> createUser(
    CreateUserDto userDto, {
    File? profileImage,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrlUser/register'),
    );

    request.fields['username'] = userDto.username;
    request.fields['email'] = userDto.email;
    request.fields['password'] = userDto.password;
    request.fields['firstName'] = userDto.firstName;
    request.fields['lastName'] = userDto.lastName;
    
    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', profileImage.path),
      );
    }

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (responseData.statusCode == 200 || responseData.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception(
        'Failed to create user. Status: ${responseData.statusCode}',
      );
    }
  }

  // PUT /users/{id} → actualiza
  Future<UserModel> updateUser(int id, UpdateUserDto userDto) async {
    final response = await http.put(
      Uri.parse('$_baseUrlUser/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userDto.toJson()),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to update user with id $id. Status: ${response.statusCode}',
      );
    }
  }

  // DELETE /users/{id} → borra
  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrlUser/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete user with id $id. Status: ${response.statusCode}',
      );
    }
  }

  Future<UserModel> getUserByEmail(String email) async {
    final response = await http.get(Uri.parse('$_baseUrlUser/\$email'));

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

  Future<LoginResponse> loginUser(LoginRequest loginRequest) async {
    final response = await http.post(
      Uri.parse('$_baseUrlUser/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LoginResponse.fromJson(json);
    } else {
      throw Exception(
        'Failed to login. Status: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
