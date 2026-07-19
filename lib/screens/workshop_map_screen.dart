import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';
import 'package:shop_and_drive/core/di/app_services.dart';
import 'package:shop_and_drive/core/theme/app_theme.dart';
import 'package:shop_and_drive/models/api_models.dart';

class WorkshopMapScreen extends StatefulWidget {
  const WorkshopMapScreen({super.key});

  @override
  State<WorkshopMapScreen> createState() => _WorkshopMapScreenState();
}

class _WorkshopMapScreenState extends State<WorkshopMapScreen> {
  LatLng? _currentLocation;
  bool _isLoadingLocation = true;
  String? _locationError;
  List<_Workshop> _workshops = [];
  bool _loadingWorkshops = true;

  static const _defaultLocation = LatLng(-6.2000, 106.8167);

  static const _fallbackWorkshops = [
    _Workshop(id: '1', name: 'Shop & Drive Kelapa Gading', address: 'Jl. Pegangsaan Dua Km 2.2, Jakarta Utara',
      location: LatLng(-6.1685, 106.9142), etaMinutes: 15, rating: 4.8,
      services: ['Tune Up', 'Ganti Oli', 'Servis Rem', 'Spooring'], region: 'Jakarta Utara'),
    _Workshop(id: '2', name: 'Shop & Drive Cempaka Putih', address: 'Jl. Cempaka Putih Raya No. 19, Jakarta Pusat',
      location: LatLng(-6.1824, 106.8732), etaMinutes: 10, rating: 4.7,
      services: ['Body Repair', 'Cat', 'AC Mobil', 'Detailing'], region: 'Jakarta Pusat'),
    _Workshop(id: '3', name: 'Shop & Drive Fatmawati', address: 'Jl. RS Fatmawati No. 89 C, Jakarta Selatan',
      location: LatLng(-6.2594, 106.7975), etaMinutes: 20, rating: 4.9,
      services: ['Tune Up', 'Kelistrikan', 'Mesin', 'Ganti Oli'], region: 'Jakarta Selatan'),
    _Workshop(id: '4', name: 'Shop & Drive Sahardjo', address: 'Jl. Dr. Saharjo No. 125, Tebet, Jakarta Selatan',
      location: LatLng(-6.2241, 106.8431), etaMinutes: 12, rating: 4.6,
      services: ['Servis Rem', 'Spooring', 'Tune Up', 'Detailing'], region: 'Jakarta Selatan'),
    _Workshop(id: '5', name: 'Shop & Drive Taman Ratu', address: 'Jl. Taman Ratu Indah No. 5, Jakarta Barat',
      location: LatLng(-6.1681, 106.7645), etaMinutes: 18, rating: 4.5,
      services: ['Ganti Oli', 'AC Mobil', 'Body Repair', 'Cat'], region: 'Jakarta Barat'),
    _Workshop(id: '6', name: 'Shop & Drive Garuda Kemayoran', address: 'Jl. Garuda No. 86, Kemayoran, Jakarta Pusat',
      location: LatLng(-6.1633, 106.8447), etaMinutes: 8, rating: 4.8,
      services: ['Tune Up', 'Home Service', 'Mesin', 'Ganti Oli'], region: 'Jakarta Pusat'),
  ];

  final MapController _mapController = MapController();
  _Workshop? _selectedWorkshop;
  List<_WorkshopDistance> _rankedWorkshops = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    final result = await AppServices.workshopRepository.fetchWorkshops();
    if (mounted) {
      result.when(
        success: (workshops) {
          final mapped = workshops.map((w) => _Workshop(
                id: w.id,
                name: w.name,
                address: w.address,
                location: LatLng(w.latitude ?? -6.2, w.longitude ?? 106.8),
                etaMinutes: _estimateEta(w.latitude ?? -6.2, w.longitude ?? 106.8),
                rating: 4.5,
                services: ['Tune Up', 'Ganti Oli'],
                region: 'Jakarta',
              )).toList();
          setState(() { _workshops = mapped.isNotEmpty ? mapped : _fallbackWorkshops; _loadingWorkshops = false; });
          _updateRanked();
        },
        failure: (_) {
          setState(() { _workshops = _fallbackWorkshops; _loadingWorkshops = false; });
          _updateRanked();
        },
      );
    }
  }

  int _estimateEta(double lat, double lng) {
    const distance = Distance();
    final location = _currentLocation ?? _defaultLocation;
    final km = distance.as(LengthUnit.Kilometer, location, LatLng(lat, lng));
    return (km * 2.5).ceil();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'Layanan lokasi tidak aktif';
        _currentLocation = _defaultLocation;
      });
      _updateRanked();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() { _isLoadingLocation = false; _locationError = 'Izin lokasi ditolak'; _currentLocation = _defaultLocation; });
        _updateRanked();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() { _isLoadingLocation = false; _locationError = 'Izin lokasi ditolak permanen'; _currentLocation = _defaultLocation; });
      _updateRanked();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() { _currentLocation = LatLng(position.latitude, position.longitude); _isLoadingLocation = false; });
      _updateRanked();
    } catch (_) {
      setState(() { _currentLocation = _defaultLocation; _isLoadingLocation = false; _locationError = 'Gagal mendapatkan lokasi'; });
      _updateRanked();
    }
  }

  void _updateRanked() {
    if (_workshops.isEmpty) return;
    const distance = Distance();
    final location = _currentLocation ?? _defaultLocation;
    final ranked = _workshops
        .map((w) => _WorkshopDistance(workshop: w, km: distance.as(LengthUnit.Kilometer, location, w.location)))
        .toList();
    ranked.sort((a, b) => a.km.compareTo(b.km));
    setState(() => _rankedWorkshops = ranked);
  }

  void _focusWorkshop(_Workshop workshop) {
    setState(() => _selectedWorkshop = workshop);
    _mapController.move(workshop.location, 15.0);
  }

  void _resetView() {
    setState(() => _selectedWorkshop = null);
    final location = _currentLocation ?? _defaultLocation;
    _mapController.move(location, 13.8);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Peta Bengkel',
      currentIndex: 2,
      actions: [
        if (_selectedWorkshop != null)
          IconButton(onPressed: _resetView, icon: const Icon(Icons.my_location_rounded), tooltip: 'Reset View'),
      ],
      body: Column(
        children: [
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation ?? _defaultLocation,
                      initialZoom: 13.8,
                      interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'shop_and_drive',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_currentLocation != null)
                            Marker(
                              point: _currentLocation!,
                              width: 46, height: 46,
                              child: const _MapPin(icon: Icons.person_pin_rounded, color: AppTheme.primary, isSelected: false),
                            ),
                          ..._rankedWorkshops.map(
                            (item) => Marker(
                              point: item.workshop.location,
                              width: 44, height: 44,
                              child: GestureDetector(
                                onTap: () => _focusWorkshop(item.workshop),
                                child: _MapPin(
                                  icon: Icons.car_repair_rounded,
                                  color: _selectedWorkshop?.id == item.workshop.id ? AppTheme.primary : AppTheme.secondary,
                                  isSelected: _selectedWorkshop?.id == item.workshop.id,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(4)),
                    child: const Text('OpenStreetMap', style: TextStyle(fontSize: 10, color: Colors.black54)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoadingLocation || _loadingWorkshops
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_locationError != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Row(children: [
                            const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                            const SizedBox(width: 6),
                            Expanded(child: Text(_locationError!, style: const TextStyle(fontSize: 12, color: Colors.orange))),
                          ]),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Row(
                          children: [
                            const Text('Bengkel Terdekat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Text('${_rankedWorkshops.length} bengkel', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _selectedWorkshop != null
                            ? _WorkshopDetailCard(
                                workshop: _selectedWorkshop!,
                                distance: _rankedWorkshops
                                    .firstWhere((w) => w.workshop.id == _selectedWorkshop!.id,
                                        orElse: () => _WorkshopDistance(workshop: _selectedWorkshop!, km: 0))
                                    .km,
                                onDismiss: () => setState(() => _selectedWorkshop = null),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                itemCount: _rankedWorkshops.length,
                                itemBuilder: (context, index) {
                                  final item = _rankedWorkshops[index];
                                  return _WorkshopCard(item: item, onTap: () => _focusWorkshop(item.workshop));
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.color, this.isSelected = false});
  final IconData icon;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
        boxShadow: const [BoxShadow(color: Color.fromARGB(61, 0, 0, 0), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Icon(icon, color: Colors.white, size: isSelected ? 22 : 20),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.item, required this.onTap});
  final _WorkshopDistance item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EBF1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
              child: const Icon(Icons.garage_rounded, color: AppTheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.workshop.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.workshop.address, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.star_rounded, size: 14, color: Colors.amber.shade600),
                  const SizedBox(width: 2),
                  Text(item.workshop.rating.toString(), style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(width: 12),
                  Text(item.workshop.region, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ]),
              ]),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${item.km.toStringAsFixed(1)} km', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('${item.workshop.etaMinutes} min', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _WorkshopDetailCard extends StatelessWidget {
  const _WorkshopDetailCard({required this.workshop, required this.distance, required this.onDismiss});
  final _Workshop workshop;
  final double distance;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(workshop.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            IconButton(onPressed: onDismiss, icon: const Icon(Icons.close, size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          ]),
          const SizedBox(height: 4),
          Text(workshop.address, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade600),
            const SizedBox(width: 4),
            Text('${workshop.rating}  •  ${distance.toStringAsFixed(1)} km  •  ${workshop.etaMinutes} min',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 6,
            children: workshop.services.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(8)),
              child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primary)),
            )).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.directions_rounded),
              label: const Text('Pesan Home Service'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Workshop {
  final String id;
  final String name;
  final String address;
  final LatLng location;
  final int etaMinutes;
  final double rating;
  final List<String> services;
  final String region;

  const _Workshop({
    required this.id, required this.name, required this.address, required this.location,
    required this.etaMinutes, required this.rating, required this.services, required this.region,
  });
}

class _WorkshopDistance {
  final _Workshop workshop;
  final double km;
  const _WorkshopDistance({required this.workshop, required this.km});
}