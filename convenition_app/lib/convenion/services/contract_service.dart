import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/contract_model.dart';

class ContractService {
  final String _baseUrl =
      "http://localhost:8080/api/contracts"; // Generic endpoint

  Future<List<ContractModel>> fetchContracts() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                ContractModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load contracts. Status: \${response.statusCode}',
      );
    }
  }

  Future<ContractModel> fetchContractById(String id) async {
    // Assuming ID is String, adjust if int
    final response = await http.get(Uri.parse('$_baseUrl/\$id'));
    if (response.statusCode == 200) {
      return ContractModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load contract \$id. Status: \${response.statusCode}',
      );
    }
  }

  Future<ContractModel> createContract(ContractModel contract) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(contract.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ContractModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to create contract. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<ContractModel> updateContract(
    String id,
    ContractModel contract,
  ) async {
    // Assuming ID is String
    final response = await http.put(
      Uri.parse('$_baseUrl/\$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(contract.toJson()),
    );
    if (response.statusCode == 200) {
      return ContractModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to update contract \$id. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<void> deleteContract(String id) async {
    // Assuming ID is String
    final response = await http.delete(Uri.parse('$_baseUrl/\$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete contract \$id. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }
}
