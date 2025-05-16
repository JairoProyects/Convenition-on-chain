class Convenio {
  final String id;
  final DateTime timestamp;
  final double monto;
  final bool firmado;
  final int participantes;
  final String hash;

  // Nuevos campos necesarios:
  final String descripcion;
  final String condiciones;
  final DateTime vencimiento;

  Convenio({
    required this.id,
    required this.timestamp,
    required this.monto,
    required this.firmado,
    required this.participantes,
    required this.hash,
    required this.descripcion,
    required this.condiciones,
    required this.vencimiento,
  });
}
