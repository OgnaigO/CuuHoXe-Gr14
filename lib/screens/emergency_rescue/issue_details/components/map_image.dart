import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapImages extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapImages({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return const Center(child: Text("Không có vị trí để hiển thị bản đồ."));
    }

    final latLng = LatLng(latitude!, longitude!);

    return SizedBox(
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          center: latLng,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLng,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
