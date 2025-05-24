import 'dart:convert';
import 'package:starknet/starknet.dart';
import 'package:starknet_provider/starknet_provider.dart';

class StarknetService {
  // Dirección real del contrato desplegado (Factory)
  final Felt factoryAddress = Felt.fromHexString(
    '0x062ea60ce5ae7d30aaf17701e44a1647bc6952fd04904c54f8b025c167c0899',
  );

  final Account cuenta;

  StarknetService(this.cuenta);

  /// Crear un nuevo convenio on-chain y devolver el hash de transacción
  Future<String> createConvenio({
  required String party1,
  required String party2,
  required String descripcion,
  required double monto,
  required String moneda,
  required String condiciones,
  required DateTime vencimiento,
  required String status, // ✅ nuevo campo
}) async {
  final txResult = await cuenta.execute(
    functionCalls: [
      FunctionCall(
        contractAddress: factoryAddress,
        entryPointSelector: getSelectorByName('create_convenio'),
        calldata: [
          Felt.fromHexString(party1),
          Felt.fromHexString(party2),
          Felt.fromString(descripcion),
          Felt.fromInt(monto.toInt()),
          Felt.fromInt(0), // high bits
          Felt.fromString(moneda),
          Felt.fromString(condiciones),
          Felt.fromInt(vencimiento.millisecondsSinceEpoch ~/ 1000),
          Felt.fromString(status), // ✅ nuevo campo al final
        ],
      ),
    ],
  );

   return txResult.when(
          result: (res) {
            print('Hash de transacción: ${res.transaction_hash}');
            return res.transaction_hash;
          },
          error: (err) => throw Exception('Error al crear convenio: ${err.message}'),
        );

  }

  /// Calcular hash de condiciones (puede usarse si querés incluirlo como referencia)
  Felt calcularHashCondiciones(String condiciones) {
    return starknetKeccak(utf8.encode(condiciones));
  }
}

Felt _stringToFelt(String input) {
  return starknetKeccak(utf8.encode(input));
}
