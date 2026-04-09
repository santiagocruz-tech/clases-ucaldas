// data/services/location_service.dart
// ──────────────────────────────────────────────────────────────
// Servicio de geolocalización. Encapsula toda la lógica de
// permisos y obtención de coordenadas GPS usando Geolocator.
// Separado de la UI para mantener la capa de datos independiente.
// ──────────────────────────────────────────────────────────────

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Resultado de una solicitud de ubicación.
///
/// Contiene:
/// - [position]: las coordenadas obtenidas (null si hubo error)
/// - [error]: mensaje descriptivo del problema (null si fue exitoso)
class LocationResult {
  final LatLng? position;
  final String? error;

  const LocationResult({this.position, this.error});

  /// True si se obtuvo la posición correctamente.
  bool get success => position != null;
}

/// Servicio que abstrae el acceso al GPS del dispositivo.
///
/// Flujo de [getCurrentLocation]:
/// 1. Verifica que los servicios de ubicación estén activos
/// 2. Comprueba/solicita permisos de ubicación
/// 3. Obtiene la posición con alta precisión
/// 4. Retorna un [LocationResult] con la posición o el error
class LocationService {
  /// Obtiene la ubicación actual del dispositivo.
  ///
  /// Retorna [LocationResult] con la posición GPS o un mensaje
  /// de error si los servicios están desactivados, los permisos
  /// fueron denegados, o hubo una excepción inesperada.
  Future<LocationResult> getCurrentLocation() async {
    try {
      // Paso 1: ¿Está el GPS activado en el dispositivo?
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult(
          error: 'Servicios de ubicación desactivados.',
        );
      }

      // Paso 2: Verificar y solicitar permisos
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          return const LocationResult(error: 'Permiso de ubicación denegado.');
        }
      }

      // El usuario marcó "no volver a preguntar"
      if (perm == LocationPermission.deniedForever) {
        return const LocationResult(error: 'Permiso denegado permanentemente.');
      }

      // Paso 3: Obtener posición con alta precisión (timeout para evitar cuelgues en web)
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LocationResult(position: LatLng(pos.latitude, pos.longitude));
    } catch (e) {
      return LocationResult(error: 'Error al obtener ubicación: $e');
    }
  }
}
