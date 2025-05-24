import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/convenio_model.dart';
import '../../shared/config/api_config.dart';

class ConvenioService {
  final String _baseUrl = ApiConfig.convenios;

  // Obtener lista de convenios
  Future<List<ConvenioModel>> fetchConvenios() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body
          .map((item) => ConvenioModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar convenios. Código: ${response.statusCode}');
    }
  }

  // Obtener un convenio por ID
  Future<ConvenioModel> fetchConvenioById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return ConvenioModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar convenio $id. Código: ${response.statusCode}');
    }
  }

  // Crear un nuevo convenio

  Future<ConvenioModel> createConvenio(CreateConvenioDto dto) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ConvenioModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al crear convenio. Código: ${response.statusCode}, Respuesta: ${response.body}');
    }
  }

  // Actualizar convenio
  Future<ConvenioModel> updateConvenio(int id, UpdateConvenioDto dto) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return ConvenioModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Error al actualizar convenio $id. Código: ${response.statusCode}, Respuesta: ${response.body}');
    }
  }

  // Eliminar convenio
  Future<void> deleteConvenio(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Error al eliminar convenio $id. Código: ${response.statusCode}, Respuesta: ${response.body}');
    }
  }
}
