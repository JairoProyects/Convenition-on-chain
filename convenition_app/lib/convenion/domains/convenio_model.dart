class ConvenioModel {
  final int id;
  final DateTime timestamp;
  final double monto;
  final String moneda;
  final String descripcion;
  final String condiciones;
  final DateTime vencimiento;
  final List<String> firmas;
  final String onChainHash;
  final String status; // lo agrego porque viene en la respuesta del backend

  ConvenioModel({
    required this.id,
    required this.timestamp,
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.firmas,
    required this.onChainHash,
    required this.status,
  });

  factory ConvenioModel.fromJson(Map<String, dynamic> json) => ConvenioModel(
        id: json['id'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
        monto: (json['monto'] as num).toDouble(),
        moneda: json['moneda'] as String,
        descripcion: json['descripcion'] as String,
        condiciones: json['condiciones'] as String,
        vencimiento: DateTime.parse(json['vencimiento'] as String),
        firmas: List<String>.from(json['firmas'] as List),
        onChainHash: json['onChainHash'] as String,
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'monto': monto,
        'moneda': moneda,
        'descripcion': descripcion,
        'condiciones': condiciones,
        'vencimiento': vencimiento.toIso8601String(),
        'firmas': firmas,
        'onChainHash': onChainHash,
        'status': status,
      };
}

class CreateConvenioDto {
  final double monto;
  final String moneda;
  final String descripcion;
  final String condiciones;
  final DateTime vencimiento;
  final List<String> firmas;
  final String onChainHash;

  CreateConvenioDto({
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.firmas,
    required this.onChainHash,
  });

  Map<String, dynamic> toJson() => {
        'monto': monto,
        'moneda': moneda,
        'descripcion': descripcion,
        'condiciones': condiciones,
        'vencimiento': vencimiento.toIso8601String(),
        'firmas': firmas,
        'onChainHash': onChainHash,
      };
}
class UpdateConvenioDto {
  final String? descripcion;
  final String? condiciones;
  final DateTime? vencimiento;
  final List<String>? firmas;
  final String? onChainHash;
  final double? monto;
  final String? moneda;
  final String? status; // Status del convenio: CREATED, IN_PROGRESS, etc.

  UpdateConvenioDto({
    this.descripcion,
    this.condiciones,
    this.vencimiento,
    this.firmas,
    this.onChainHash,
    this.monto,
    this.moneda,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (descripcion != null) data['descripcion'] = descripcion;
    if (condiciones != null) data['condiciones'] = condiciones;
    if (vencimiento != null) data['vencimiento'] = vencimiento!.toIso8601String();
    if (firmas != null) data['firmas'] = firmas;
    if (onChainHash != null) data['onChainHash'] = onChainHash;
    if (monto != null) data['monto'] = monto;
    if (moneda != null) data['moneda'] = moneda;
    if (status != null) data['status'] = status;
    return data;
  }
}

class AgreementDraft {
  final double monto;
  final String moneda;
  final String descripcion;
  final String condiciones;
  final DateTime vencimiento;
  final String party1; // la wallet del creador
  final String party2; // la wallet del segundo firmante o usuario seleccionado

  AgreementDraft({
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.party1,
    required this.party2,
  });
}
