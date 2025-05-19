import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';
import 'package:http/http.dart' as http;

class StarknetService {
  // Dirección del contrato ConvenioCore (ajustar con la real)
  final Felt contratoConvenioCore = Felt.fromHexString(
    '0x0123456789abcdef',
  ); // TEMPORAL
  final Account cuenta;

  StarknetService(this.cuenta);

  /// Crear un nuevo convenio en la blockchain
  Future<Felt> createConvenio({
    required String descripcion,
    required String condiciones,
    required DateTime vencimiento,
  }) async {
    final hashContenido = _calcularHash(condiciones);

    final response = await cuenta.execute(
      functionCalls: [
        FunctionCall(
          contractAddress: contratoConvenioCore,
          entryPointSelector: getSelectorByName('create_convenio'),
          calldata: [
            _stringToFelt(descripcion),
            hashContenido,
            Felt.fromInt(vencimiento.millisecondsSinceEpoch ~/ 1000),
          ],
        ),
      ],
    );

    final txHash = response.when(
      result: (res) {
        print('Contenido de result: $res');
        return res; // O ajusta aquí según estructura real
      },
      error: (err) => throw Exception('Error: ${err.message}'),
    );

    return contratoConvenioCore;
  }

  /// Calcular un hash felt del contenido textual usando starknetKeccak
  Felt _calcularHash(String content) {
    return starknetKeccak(utf8.encode(content));
  }

  /// Convertir una cadena de texto a Felt usando keccak para asegurar tamaño seguro
  Felt _stringToFelt(String input) {
    return starknetKeccak(utf8.encode(input));
  }

  /// (Opcional) Escuchar eventos emitidos por el contrato
  Stream<String> listenConvenioEvents() async* {
    // Dependerá de integración vía nodo y suscripción, por ahora placeholder
    yield* Stream.periodic(const Duration(seconds: 10), (_) => 'Nuevo evento');
  }
}

// Define your User model (UserDto equivalent)
class User {
  final int? id; // Nullable if it's not present for new users
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  // Add other fields like status, createdAt, updatedAt as needed

  User({
    this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}

// Define your CreateUserRequest model
class CreateUserRequest {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  CreateUserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
  };
}

// Define your UpdateUserRequest model
class UpdateUserRequest {
  final String firstName;
  final String lastName;
  // final String status; // Assuming status is a string, adjust if it's an enum

  UpdateUserRequest({
    required this.firstName,
    required this.lastName,
    // required this.status,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    // 'status': status,
  };
}

class UserService {
  // Replace with your actual backend URL
  // For local development with Android emulator, use 10.0.2.2
  // For iOS simulator, usually localhost or 127.0.0.1 works
  // If running Flutter web and backend on same machine, localhost should work
  static const String _baseUrl =
      "http://10.0.2.2:8080/users"; // Example for Android Emulator

  Future<User> createUser(CreateUserRequest request) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // 201 is typically for created
      return User.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );
    } else {
      // Consider more specific error handling based on status code or response body
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<User> users =
          body
              .map(
                (dynamic item) => User.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateUser(int id, UpdateUserRequest request) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 204) {
      // 204 No Content for successful deletion
      throw Exception('Failed to delete user');
    }
  }
}
