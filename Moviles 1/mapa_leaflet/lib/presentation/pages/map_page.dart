// presentation/pages/map_page.dart
// ──────────────────────────────────────────────────────────────
// Página principal de la aplicación. Contiene el mapa interactivo,
// la lógica de estado (ubicación, lugares guardados) y coordina
// los widgets de presentación (sheets, marcadores, errores).
// ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/services/location_service.dart';
import '../../domain/entities/saved_place.dart';
import '../widgets/save_place_sheet.dart';
import '../widgets/saved_places_sheet.dart';
import '../widgets/map_error_card.dart';

/// Pantalla principal que contiene el mapa.
///
/// Es un StatefulWidget porque maneja estado mutable:
/// la posición actual, los lugares guardados, estados de carga y errores.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

/// Estado de [MapPage].
///
/// Gestiona:
/// - [_mapController]: controlador para mover/hacer zoom programáticamente
/// - [_locationService]: servicio de geolocalización (capa de datos)
/// - [_currentPosition]: coordenadas GPS actuales (null si no se obtienen)
/// - [_loading]: indica si se está obteniendo la ubicación
/// - [_error]: mensaje de error si algo falla con GPS/permisos
/// - [_savedPlaces]: lista en memoria de lugares guardados
class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  LatLng? _currentPosition;
  bool _loading = true;
  String? _error;
  final List<SavedPlace> _savedPlaces = [];

  /// Se ejecuta al crear el widget. Inmediatamente obtiene la ubicación.
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ─────────────────────────────────────────────────────────
  // GEOLOCALIZACIÓN
  // ─────────────────────────────────────────────────────────

  /// Solicita la ubicación actual al [LocationService].
  ///
  /// Delega toda la lógica de permisos y GPS al servicio.
  /// Si es exitoso, mueve el mapa a la posición con zoom 15.
  /// Si falla, muestra el error en una tarjeta roja.
  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _locationService.getCurrentLocation();

    setState(() {
      _currentPosition = result.position;
      _error = result.error;
      _loading = false;
    });

    if (result.success) {
      _mapController.move(_currentPosition!, 15);
    }
  }

  // ─────────────────────────────────────────────────────────
  // GUARDAR UBICACIÓN
  // ─────────────────────────────────────────────────────────

  /// Abre el bottom sheet para guardar la ubicación actual.
  ///
  /// Si no hay ubicación disponible, muestra un SnackBar de aviso.
  /// Al guardar, agrega el lugar a [_savedPlaces] y muestra confirmación.
  void _showSaveDialog() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Esperando ubicación...')));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite ajustarse al teclado
      builder: (_) => SavePlaceSheet(
        position: _currentPosition!,
        onSave: (place) {
          // Agregar el lugar y mostrar confirmación
          setState(() => _savedPlaces.add(place));
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('"${place.name}" guardado')));
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // LISTA DE LUGARES GUARDADOS
  // ─────────────────────────────────────────────────────────

  /// Abre el bottom sheet con la lista de lugares guardados.
  ///
  /// Al tocar un lugar, cierra el sheet y centra el mapa ahí.
  /// Al eliminar, refresca la lista reabriendo el sheet.
  void _showSavedPlaces() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SavedPlacesSheet(
        places: _savedPlaces,
        onPlaceTap: (place) {
          Navigator.pop(ctx);
          _mapController.move(place.position, 16);
        },
        onDelete: (index) {
          setState(() => _savedPlaces.removeAt(index));
          Navigator.pop(ctx); // Cerrar el sheet actual
          // Esperar a que se cierre antes de reabrir para evitar apilar sheets
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _showSavedPlaces();
          });
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // MARCADORES
  // ─────────────────────────────────────────────────────────

  /// Construye la lista de marcadores para el mapa.
  ///
  /// Incluye:
  /// 1. Marcador azul de "mi ubicación" (icono my_location)
  /// 2. Un marcador por cada lugar guardado con icono/color de su categoría
  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Marcador de ubicación actual (azul)
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: _currentPosition!,
          width: 40,
          height: 40,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 36),
        ),
      );
    }

    // Marcadores de lugares guardados
    for (final p in _savedPlaces) {
      markers.add(
        Marker(
          point: p.position,
          width: 40,
          height: 40,
          child: Icon(p.category.icon, color: p.category.color, size: 36),
        ),
      );
    }

    return markers;
  }

  // ─────────────────────────────────────────────────────────
  // INTERFAZ DE USUARIO
  // ─────────────────────────────────────────────────────────

  /// Construye la interfaz principal.
  ///
  /// Layout:
  /// - AppBar: título + botones (lista guardados, mi ubicación)
  /// - Body: Stack con mapa, indicador de carga y tarjeta de error
  /// - FAB: "Guardar lugar" para abrir el formulario
  @override
  Widget build(BuildContext context) {
    // Fallback a Madrid si no hay ubicación aún
    final center = _currentPosition ?? const LatLng(40.4168, -3.7038);

    return Scaffold(
      // ── Barra superior ──
      appBar: AppBar(
        title: const Text('Mapa Leaflet'),
        actions: [
          // Botón: ver lista de lugares guardados
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _showSavedPlaces,
            tooltip: 'Lugares guardados',
          ),
          // Botón: re-centrar mapa en ubicación actual
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
            tooltip: 'Mi ubicación',
          ),
        ],
      ),

      // ── Botón flotante para guardar ubicación ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSaveDialog,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Guardar lugar'),
      ),

      // ── Cuerpo: mapa + overlays de estado ──
      body: Stack(
        children: [
          // Capa 1: Mapa interactivo con tiles de OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: center, initialZoom: 13),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.mapa_leaflet',
              ),
              // Capa de marcadores: ubicación actual + lugares guardados
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),

          // Capa 2: Indicador de carga
          if (_loading) const Center(child: CircularProgressIndicator()),

          // Capa 3: Tarjeta de error
          if (_error != null) MapErrorCard(error: _error!),
        ],
      ),
    );
  }
}
