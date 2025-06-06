import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';  // Import từ latlong2
import 'package:flutter_application_1/config/size_config.dart';
import 'components/body.dart';

class MapPickerScreen extends StatelessWidget {
  static String routeName = "/route_name";

  // Tham số truyền vào từ bên ngoài khi gọi screen
  final Function(LatLng _latLngSelected, String _addressSelected) onPlacePicked;
  final LatLng? initialCameraPosition;

  MapPickerScreen({
    required this.onPlacePicked,
    this.initialCameraPosition,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Khởi tạo kích thước màn hình (SizeConfig)
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Map Picker",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(
        onPlacePicked: onPlacePicked, // Truyền hàm callback chọn vị trí
        initialCameraPosition: initialCameraPosition, // Vị trí bắt đầu (có thể là null)
      ),
    );
  }
}
