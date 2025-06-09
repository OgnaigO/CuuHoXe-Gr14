import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/config/constants.dart';
import 'package:flutter_application_1/config/size_config.dart';
import 'package:flutter_application_1/helper/location_helper.dart';

class Body extends StatefulWidget {
  LatLng? initialCameraPosition;
  Function(LatLng _latLngSelected, String _addressSelected) onPlacePicked;

  Body({
    this.initialCameraPosition,
    required this.onPlacePicked,
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _addressSelected = "Chạm vào bản đồ để chọn vị trí";
  LatLng? _latLngSelected;
  bool isPlaceAddressLoading = false;

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _onTap(LatLng newLatLng) async {
    setState(() {
      _latLngSelected = newLatLng;
      isPlaceAddressLoading = true;
    });

    try {
      _addressSelected = await LocationHelper.getPlaceAddress(
        newLatLng.latitude,
        newLatLng.longitude,
      );
    } catch (_) {
      _addressSelected = "Không lấy được địa chỉ.";
    }

    setState(() {
      isPlaceAddressLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng defaultPosition = widget.initialCameraPosition ??
        LatLng(20.9920107, 105.8599154); // fallback vị trí

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: defaultPosition,
              zoom: 15.0,
              onTap: (tapPosition, latLng) => _onTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_latLngSelected != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _latLngSelected!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(top: 0, child: _panelTop(opacity: 0.9)),
          Positioned(bottom: 10, child: _panelBottom(opacity: 0.9)),
        ],
      ),
    );
  }

  Widget _panelTop({required double opacity}) {
    return Container(
      width: SizeConfig.screenWidth * 0.95,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Text(
          "Chạm vào bản đồ để chọn vị trí",
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _panelBottom({required double opacity}) {
    return Container(
      width: SizeConfig.screenWidth * 0.95,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 18),
          isPlaceAddressLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                  ),
                  child: Text(
                    _addressSelected,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.75,
                child: DefaultButton(
                  text: "Xác nhận",
                  press: () {
                    if (_latLngSelected != null) {
                      widget.onPlacePicked(
                          _latLngSelected!, _addressSelected);
                    }
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
