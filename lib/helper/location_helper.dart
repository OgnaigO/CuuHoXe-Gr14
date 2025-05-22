import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';

const String GOOGLE_API_KEY = 'AIzaSyCPGSoVHrfLmvJO6TF760Sc1IlbwNUkj5M';
const String _locationDataKey = "Location_Data";

class LocationHelper {
  /// Lấy ảnh bản đồ thu nhỏ từ toạ độ
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
    int width = 600,
    int height = 300,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$latitude,$longitude'
        '&zoom=16&size=${width}x$height'
        '&markers=color:red|$latitude,$longitude'
        '&key=$GOOGLE_API_KEY';
  }

  /// Lấy địa chỉ từ toạ độ thông qua Google Geocoding API
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?latlng=$lat,$lng&key=$GOOGLE_API_KEY',
    );

    final response = await http.get(url);
    final data = json.decode(response.body);
    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      return data['results'][0]['formatted_address'];
    } else {
      throw Exception('Không tìm thấy địa chỉ.');
    }
  }

  /// Lấy vị trí hiện tại (cross-platform)
  static Future<LatLng> getCurrentLocation() async {
    if (kIsWeb) {
      // Dành cho Flutter Web → dùng geolocator
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Dịch vụ định vị đang tắt. Hãy bật vị trí.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          throw Exception("Bạn chưa cấp quyền truy cập vị trí.");
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Hết thời gian chờ phản hồi từ GPS.");
      });

      return LatLng(position.latitude, position.longitude);
    } else {
      // Dành cho Android/iOS → dùng plugin `location`
      final loc.Location location = loc.Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception("Hãy bật dịch vụ định vị và thử lại.");
        }
      }

      loc.PermissionStatus permission = await location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != loc.PermissionStatus.granted) {
          throw Exception("Không được cấp quyền truy cập vị trí.");
        }
      }

      final locationData = await location.getLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("GPS phản hồi quá chậm. Thử lại sau.");
        },
      );

      return LatLng(locationData.latitude!, locationData.longitude!);
    }
  }

  /// Lưu/trả lại vị trí từ cache (SharedPreferences)
  static Future<LatLng> getCurrentLocationCache({bool refresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (refresh || !prefs.containsKey(_locationDataKey)) {
      final current = await getCurrentLocation();
      prefs.setString(
        _locationDataKey,
        json.encode({
          'lat': current.latitude,
          'lng': current.longitude,
        }),
      );
      return current;
    }

    final extracted =
        json.decode(prefs.getString(_locationDataKey)!) as Map<String, dynamic>;
    return LatLng(extracted['lat'], extracted['lng']);
  }

  /// Tính khoảng cách từ vị trí hiện tại đến một toạ độ cho trước (km)
  static Future<double> getDistanceInKilometers(
      double startLatitude, double startLongitude) async {
    final current = await getCurrentLocationCache();

    final distance = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      current.latitude,
      current.longitude,
    );

    return distance / 1000;
  }
}