// lib/utils/blacklist.dart

final List<String> blacklistNombresResidencias = [
  'Matías Soto Altamirano',
  'Residencia Central',
  'Test',
  'Demo',
];

/// Verifica si el nombre de la residencia está permitido
bool esNombreResidenciaPermitido(String nombre) {
  return !blacklistNombresResidencias.any((prohibido) =>
      nombre.toLowerCase().contains(prohibido.toLowerCase()));
}
