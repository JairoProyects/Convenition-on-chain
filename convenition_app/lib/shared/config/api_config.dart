class ApiConfig {
  static const String baseDomain = "https://www.devbychris.com/convenio-api";

  // Endpoints agrupados
  static const String userDetails = "$baseDomain/api/userdetails";
  static const String users = "$baseDomain/users";
  static const String detailsUsers = "$baseDomain/api/detailsUsers";
  static String profileImage(int userId) => "$users/$userId/profile-image";

  // Endpoints de convenios
  static const String convenios     = "$baseDomain/api/convenios";
  static const String convenioById  = convenios;                // + '/{id}'
  static const String convenioByExternal  = "$convenios/external"; // + '/{externalId}'
  static const String convenioByHash      = "$convenios/hash";     // + '/{onChainHash}'

  // API de Hacienda (consulta por cédula)
  static const String haciendaBase = "https://api.hacienda.go.cr/fe/ae?identificacion=";

  // Agrega más endpoints reutilizables aquí
}
