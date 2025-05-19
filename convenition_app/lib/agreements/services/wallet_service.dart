import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domains/wallet_model.dart';

class WalletService {
  final String _baseUrl =
      "http://localhost:8080/api/wallets"; // Generic endpoint

  Future<List<WalletModel>> fetchWallets() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body
          .map(
            (dynamic item) =>
                WalletModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load wallets. Status: \${response.statusCode}',
      );
    }
  }

  Future<WalletModel> fetchWalletById(String id) async {
    // Assuming ID is String, adjust if int
    final response = await http.get(Uri.parse('$_baseUrl/\$id'));
    if (response.statusCode == 200) {
      return WalletModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to load wallet \$id. Status: \${response.statusCode}',
      );
    }
  }

  Future<WalletModel> createWallet(WalletModel wallet) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(wallet.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return WalletModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to create wallet. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<WalletModel> updateWallet(String id, WalletModel wallet) async {
    // Assuming ID is String
    final response = await http.put(
      Uri.parse('$_baseUrl/\$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(wallet.toJson()),
    );
    if (response.statusCode == 200) {
      return WalletModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Failed to update wallet \$id. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }

  Future<void> deleteWallet(String id) async {
    // Assuming ID is String
    final response = await http.delete(Uri.parse('$_baseUrl/\$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete wallet \$id. Status: \${response.statusCode}, Body: \${response.body}',
      );
    }
  }
}
