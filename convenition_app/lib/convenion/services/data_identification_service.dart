import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/config/api_config.dart';

class DataIdentificationService {
  Future<Map<String, dynamic>?> getNameByIdentification(String cedula) async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.haciendaBase}$cedula'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['nombre'] != null) {
          return data;
        } else {
          return null;
        }
      } else {
        throw Exception('Error al consultar Hacienda: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en HaciendaService: $e');
      return null;
    }
  }
}
