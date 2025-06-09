import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';  // Import LatLng from latlong2
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';  // Import flutter_map for OpenStreetMap
import 'package:flutter_application_1/providers/garage_provider.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<GarageProvider>(
        builder: (context, garageProvider, child) {
          return FlutterMap(
            options: MapOptions(
              center: garageProvider.items.isNotEmpty
                  ? LatLng(
                      garageProvider.items[0].latitude!,
                      garageProvider.items[0].longitude!,
                    )
                  : LatLng(0, 0), // Default position if no garages
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // OpenStreetMap tile URL
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: garageProvider.items.isNotEmpty
                    ? garageProvider.items.map<Marker>((e) {
                        return Marker(
                          point: LatLng(e.latitude!, e.longitude!),  // LatLng from latlong2
                          width: 80.0,
                          height: 80.0,
                          child: Icon(Icons.location_on, color: Colors.red, size: 40), // Added child as an Icon
                        );
                      }).toList()
                    : [],
              ),
            ],
          );
        },
      ),
    );
  }
}
