import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/convenio_model.dart';
import '../domains/convenio_model.dart';

class ConvenioService {
  final String _baseUrl = "http://localhost:8080/api/convenios";

  Future<List<ConvenioModel>> fetchConvenios() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body
          .map((item) => ConvenioModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load convenios. Status: ${response.statusCode}');
    }
  }

  Future<ConvenioModel> fetchConvenioById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode == 200) {
      return ConvenioModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load convenio $id. Status: ${response.statusCode}');
    }
  }

  Future<ConvenioModel> createConvenio(CreateConvenioDto dto) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ConvenioModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create convenio. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<ConvenioModel> updateConvenio(String id, UpdateConvenioDto dto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(dto.toJson()),
    );
    if (response.statusCode == 200) {
      return ConvenioModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update convenio $id. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> deleteConvenio(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete convenio $id. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}

