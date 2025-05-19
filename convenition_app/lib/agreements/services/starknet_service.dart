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
