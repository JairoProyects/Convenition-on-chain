class ConvenioModel {
  final String id;                     // ID off-chain o on-chain
  final DateTime timestamp;           // Fecha de creación
  final double monto;                 // Monto acordado
  final String moneda;                // Tipo de moneda (₡, $, Ξ, ₿, etc.)
  final String descripcion;           // Breve descripción
  final String condiciones;           // Detalles o condiciones
  final DateTime vencimiento;         // Fecha de vencimiento
  final List<String> firmas;          // Firmas on-chain
  final String hash;                  // Hash para referencia on-chain

  ConvenioModel({
    required this.id,
    required this.timestamp,
    required this.monto,
    required this.moneda,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.firmas,
    required this.hash,
  });

  factory ConvenioModel.fromJson(Map<String, dynamic> json) {
    return ConvenioModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      monto: json['monto'].toDouble(),
      moneda: json['moneda'],
      descripcion: json['descripcion'],
      condiciones: json['condiciones'],
      vencimiento: DateTime.parse(json['vencimiento']),
      firmas: List<String>.from(json['firmas'] ?? []),
      hash: json['hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'monto': monto,
      'moneda': moneda,
      'descripcion': descripcion,
      'condiciones': condiciones,
      'vencimiento': vencimiento.toIso8601String(),
      'firmas': firmas,
      'hash': hash,
    };
  }
}
