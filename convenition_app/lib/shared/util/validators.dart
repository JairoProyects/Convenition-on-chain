// lib/shared/utils/validators.dart

String? validateRequired(String? value, {String fieldName = "Campo"}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName es requerido';
  }
  return null;
}

String? validatePositiveNumber(String? value, {String fieldName = "Valor"}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName es requerido';
  }
  final number = double.tryParse(value);
  if (number == null || number <= 0) {
    return '$fieldName debe ser un número positivo';
  }
  return null;
}

String? validateInteger(String? value, {String fieldName = "Número"}) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName es requerido';
  }
  final number = int.tryParse(value);
  if (number == null || number <= 0) {
    return '$fieldName debe ser un número entero positivo';
  }
  return null;
}
