class ConvenioModel {
  final String id;
  final String   externalId;
  final DateTime timestamp;
  final double   monto;
  final String   moneda;
  final String   descripcion;
  final String   condiciones;
  final DateTime vencimiento;
  final List<String> firmas;
  final String   onChainHash;

  ConvenioModel({
    required this.id,
    required this.externalId,
    required this.timestamp,
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.firmas,
    required this.onChainHash,
  });

  factory ConvenioModel.fromJson(Map<String, dynamic> json) => ConvenioModel(
        id:          json['id'] as String,
        externalId:  json['externalId'] as String,
        timestamp:   DateTime.parse(json['timestamp'] as String),
        monto:       (json['monto'] as num).toDouble(),
        moneda:      json['moneda'] as String,
        descripcion: json['descripcion'] as String,
        condiciones: json['condiciones'] as String,
        vencimiento: DateTime.parse(json['vencimiento'] as String),
        firmas:      List<String>.from(json['firmas'] as List),
        onChainHash: json['onChainHash'] as String,
      );

  Map<String, dynamic> toJson() => {
        'externalId':   externalId,
        'monto':        monto,
        'moneda':       moneda,
        'descripcion':  descripcion,
        'condiciones':  condiciones,
        'vencimiento':  vencimiento.toIso8601String(),
        'firmas':       firmas,
        'onChainHash':  onChainHash,
      };
}

class CreateConvenioDto {
  final String   externalId;
  final double   monto;
  final String   moneda;
  final String   descripcion;
  final String   condiciones;
  final DateTime vencimiento;
  final List<String> firmas;
  final String   onChainHash;

  CreateConvenioDto({
    required this.externalId,
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.firmas,
    required this.onChainHash,
  });

  Map<String, dynamic> toJson() => {
        'externalId':   externalId,
        'monto':        monto,
        'moneda':       moneda,
        'descripcion':  descripcion,
        'condiciones':  condiciones,
        'vencimiento':  vencimiento.toIso8601String(),
        'firmas':       firmas,
        'onChainHash':  onChainHash,
      };
}

class UpdateConvenioDto {
  final String?   descripcion;
  final String?   condiciones;
  final DateTime? vencimiento;
  final List<String>? firmas;
  final String?   onChainHash;

  UpdateConvenioDto({
    this.descripcion,
    this.condiciones,
    this.vencimiento,
    this.firmas,
    this.onChainHash,
  });

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    if (descripcion  != null) m['descripcion']  = descripcion;
    if (condiciones  != null) m['condiciones']  = condiciones;
    if (vencimiento  != null) m['vencimiento']  = vencimiento!.toIso8601String();
    if (firmas       != null) m['firmas']       = firmas;
    if (onChainHash  != null) m['onChainHash']  = onChainHash;
    return m;
  }
}
