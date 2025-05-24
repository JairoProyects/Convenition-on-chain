import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../domains/profile_image_response.dart';
import 'package:convenition_app/shared/config/api_config.dart';

class UserProfileService {
  Future<ProfileImageResponse> uploadProfileImage({
    required int userId,
    required File imageFile,
  }) async {

    final uri = Uri.parse(ApiConfig.profileImage(userId));

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return ProfileImageResponse.fromJson(json);
    } else {
      throw Exception(
        'Error uploading profile image (${res.statusCode}): ${res.body}',
      );
    }
  }
}
