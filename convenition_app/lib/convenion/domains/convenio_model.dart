class ConvenioModel {
  final String id;                    // ID off-chain o on-chain
  final DateTime timestamp;          // Fecha de creación (off-chain)
  final double monto;                // Valor económico acordado
  final bool firmado;                // Estado off-chain (deprecated, usar status)
  final int participantes;           // Cantidad de firmantes
  final String hash;                 // Hash del contenido (on-chain reference)

  final String descripcion;          // Breve descripción (title)
  final String condiciones;          // Contenido detallado (content)
  final DateTime vencimiento;        // Expiración (expiration en Cairo)

  // Nuevos campos alineados con Cairo/backend
  final List<String> firmas;         // Firmas on-chain
  final String estado;               // Estado: Idle, SignedByOne, Completed

  ConvenioModel({
    required this.id,
    required this.timestamp,
    required this.monto,
    required this.firmado,
    required this.participantes,
    required this.hash,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
    required this.firmas,
    required this.estado,
  });

  // Método auxiliar si luego conectas con backend
  factory ConvenioModel.fromJson(Map<String, dynamic> json) {
    return ConvenioModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      monto: json['monto'].toDouble(),
      firmado: json['firmado'],
      participantes: json['participantes'],
      hash: json['hash'],
      descripcion: json['descripcion'],
      condiciones: json['condiciones'],
      vencimiento: DateTime.parse(json['vencimiento']),
      firmas: List<String>.from(json['firmas'] ?? []),
      estado: json['estado'] ?? 'Idle',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'monto': monto,
      'firmado': firmado,
      'participantes': participantes,
      'hash': hash,
      'descripcion': descripcion,
      'condiciones': condiciones,
      'vencimiento': vencimiento.toIso8601String(),
      'firmas': firmas,
      'estado': estado,
    };
  }
}
