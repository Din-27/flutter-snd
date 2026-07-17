import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shop_and_drive/components/layout/app_page_scaffold.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  static const _currentLocation = LatLng(-8.6502, 116.3249);

  static const _workshops = [
    _Workshop(
      name: 'Bengkel Prima Motor',
      address: 'Jl. Raya Mataram No. 12',
      location: LatLng(-8.6489, 116.3160),
      etaMinutes: 9,
    ),
    _Workshop(
      name: 'Bengkel Nusantara Service',
      address: 'Jl. Ahmad Yani No. 33',
      location: LatLng(-8.6625, 116.3298),
      etaMinutes: 14,
    ),
    _Workshop(
      name: 'Bengkel Sahabat Mobil',
      address: 'Jl. Sriwijaya No. 20',
      location: LatLng(-8.6403, 116.3387),
      etaMinutes: 16,
    ),
    _Workshop(
      name: 'AutoCare Home Service Hub',
      address: 'Jl. Udayana No. 88',
      location: LatLng(-8.6571, 116.3022),
      etaMinutes: 21,
    ),
  ];

  List<_WorkshopDistance> _sortedByDistance() {
    const distance = Distance();
    final ranked = _workshops
        .map(
          (workshop) => _WorkshopDistance(
            workshop: workshop,
            km: distance.as(
              LengthUnit.Kilometer,
              _currentLocation,
              workshop.location,
            ),
          ),
        )
        .toList();

    ranked.sort((a, b) => a.km.compareTo(b.km));
    return ranked;
  }

  @override
  Widget build(BuildContext context) {
    final rankedWorkshops = _sortedByDistance();
    final nearest = rankedWorkshops.first;

    final techRoute = [
      nearest.workshop.location,
      LatLng(
        (nearest.workshop.location.latitude + _currentLocation.latitude) / 2,
        nearest.workshop.location.longitude,
      ),
      LatLng(
        _currentLocation.latitude,
        (nearest.workshop.location.longitude + _currentLocation.longitude) / 2,
      ),
      _currentLocation,
    ];

    final technicianLocation = techRoute[2];

    return AppPageScaffold(
      title: 'Monitoring Bengkel',
      currentIndex: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 290,
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: _currentLocation,
                    initialZoom: 13.8,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'shop_and_drive',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: techRoute,
                          color: const Color(0xFF3F7CAC),
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocation,
                          width: 46,
                          height: 46,
                          child: const _MapPin(
                            icon: Icons.home_rounded,
                            color: Color(0xFF2A9D8F),
                          ),
                        ),
                        ...rankedWorkshops.map(
                          (item) => Marker(
                            point: item.workshop.location,
                            width: 42,
                            height: 42,
                            child: const _MapPin(
                              icon: Icons.car_repair_rounded,
                              color: Color(0xFFE76F51),
                            ),
                          ),
                        ),
                        Marker(
                          point: technicianLocation,
                          width: 48,
                          height: 48,
                          child: const _MapPin(
                            icon: Icons.delivery_dining_rounded,
                            color: Color(0xFF264653),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Map data: OpenStreetMap (gratis)',
              style: TextStyle(fontSize: 11, color: Color(0xFF6D6A69)),
            ),
            const SizedBox(height: 18),
            const Text(
              'Bengkel Terdekat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ...rankedWorkshops.take(3).map((item) {
              return _WorkshopCard(item: item);
            }),
            const SizedBox(height: 14),
            _HomeServiceProgressCard(nearest: nearest),
          ],
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(61, 0, 0, 0),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.item});

  final _WorkshopDistance item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6DFDD)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.garage_rounded, color: Color(0xFF6C5A55)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.workshop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF39312F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.workshop.address,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.km.toStringAsFixed(1)} km',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                '${item.workshop.etaMinutes} min',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeServiceProgressCard extends StatelessWidget {
  const _HomeServiceProgressCard({required this.nearest});

  final _WorkshopDistance nearest;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE3EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monitoring Perjalanan Home Service',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Teknisi berangkat dari ${nearest.workshop.name}',
            style: const TextStyle(color: Color(0xFF5F5A58)),
          ),
          const SizedBox(height: 12),
          const _TimelineStep(
            isDone: true,
            title: 'Order diterima bengkel',
            subtitle: '09:12',
          ),
          const _TimelineStep(
            isDone: true,
            title: 'Teknisi berangkat',
            subtitle: '09:18',
          ),
          _TimelineStep(
            isDone: false,
            title: 'Dalam perjalanan (ETA ${nearest.workshop.etaMinutes} menit)',
            subtitle: 'Live tracking aktif',
          ),
          const _TimelineStep(
            isDone: false,
            title: 'Tiba dan mulai pengecekan',
            subtitle: 'Menunggu',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.isDone,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  final bool isDone;
  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = isDone ? const Color(0xFF2A9D8F) : const Color(0xFFB7C1D1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: const Color(0xFFD0D7E2),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6D6A69)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Workshop {
  const _Workshop({
    required this.name,
    required this.address,
    required this.location,
    required this.etaMinutes,
  });

  final String name;
  final String address;
  final LatLng location;
  final int etaMinutes;
}

class _WorkshopDistance {
  const _WorkshopDistance({required this.workshop, required this.km});

  final _Workshop workshop;
  final double km;
}
