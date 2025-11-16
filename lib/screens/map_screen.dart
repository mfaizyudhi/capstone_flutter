import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  static const LatLng _defaultLocation = LatLng(-6.200000, 106.816666);
  LatLng _currentLocation = _defaultLocation;

  List<Marker> _markers = [];

  /// =============================
  /// GET CURRENT LOCATION
  /// =============================
  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktifkan GPS Anda')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    LatLng pos = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = pos;
      _markers = [
        Marker(
          point: pos,
          width: 40,
          height: 40,
          child: const Icon(Icons.location_on, size: 40, color: Colors.red),
        ),
      ];
    });

    _mapController.move(pos, 15);
  }

  /// =============================
  /// SEARCH LOCATION (OSM)
  /// =============================
  Future<void> _searchLocation() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1",
    );

    final response = await http.get(
      url,
      headers: {"User-Agent": "flutter-app"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi tidak ditemukan')),
        );
        return;
      }

      final lat = double.parse(data[0]["lat"]);
      final lon = double.parse(data[0]["lon"]);
      final pos = LatLng(lat, lon);

      setState(() {
        _markers = [
          Marker(
            point: pos,
            width: 40,
            height: 40,
            child: const Icon(Icons.place, size: 40, color: Colors.blue),
          ),
        ];
      });

      _mapController.move(pos, 14);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error menghubungi server')),
      );
    }
  }

  /// =============================
  /// UI
  /// =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultLocation,
              initialZoom: 12,
              minZoom: 3,
              maxZoom: 18,

              // 👉 FIX: Biar bisa drag, zoom, rotate
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.app",
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          /// ============================
          /// SEARCH BOX
          /// ============================
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari lokasi...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _searchLocation(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _searchLocation,
                  ),
                ],
              ),
            ),
          ),

          /// ============================
          /// CURRENT LOCATION BUTTON
          /// ============================
          Positioned(
            bottom: 40,
            right: 20,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.my_location, color: Colors.blueAccent),
            ),
          ),

          /// ============================
          /// ZOOM BUTTONS (+ / -)
          /// ============================
          Positioned(
            bottom: 120,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    final cam = _mapController.camera;
                    _mapController.move(cam.center, cam.zoom + 1);
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    final cam = _mapController.camera;
                    _mapController.move(cam.center, cam.zoom - 1);
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
