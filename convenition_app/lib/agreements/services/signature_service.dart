import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/signature_model.dart';

class SignatureService {
  final String _baseUrl = "http://localhost:8080/api/signatures";

  Future<SignatureModel> saveSignature(SignatureModel signature) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(signature.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SignatureModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to save signature. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<List<SignatureModel>> getSignaturesForContract(int contractId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/contract/\$contractId'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                SignatureModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load signatures for contract \$contractId. Status: \${response.statusCode}',
      );
    }
  }

  Future<List<SignatureModel>> getSignaturesByWalletId(int walletId) async {
    final response = await http.get(Uri.parse('$_baseUrl/wallet/\$walletId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                SignatureModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load signatures for wallet \$walletId. Status: \${response.statusCode}',
      );
    }
  }
}
