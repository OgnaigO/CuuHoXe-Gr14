import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpHelper {
  static String accessToken = "";

  static Map<String, String> get _authHeader {
    return {
      'Authorization': 'Bearer $accessToken',
    };
  }

  static Future<dynamic> get({required String url}) async {
    //https://flutter.dev/docs/cookbook/networking/fetch-data
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          ..._authHeader,
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw TimeoutException(
              'Hết thời gian chờ máy chủ phản hồi. Vui lòng kiểm tra internet và thử lại!');
        },
      );

      if (response.body.isEmpty) {
        throw const HttpException(
            '❌ Failed to fetch all data. ResponseBody is Empty');
      }

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        //return json.decode(response.body); //dùng cách mặc định này bị lỗi font utf8
        //return json.decode(const Utf8Decoder().convert(response.bodyBytes)); //cách này cũng tạm ok
        return json.decode(utf8.decode(response.bodyBytes)); //cách này gọn nhất
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw HttpException('❌ Không thể tìm nạp tất cả dữ liệu. \nStatusCode: ' +
            response.statusCode.toString() +
            "\nMessage: " +
            (json.decode(utf8.decode(response.bodyBytes))['message'] ?? ""));
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> post({required String url, Object? body}) async {
    try {
      print(body);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          ..._authHeader,
        },
        body: body,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw TimeoutException(
              'Hết thời gian chờ máy chủ phản hồi. Vui lòng kiểm tra internet và thử lại!');
        },
      );

      if (response.body.isEmpty) {
        throw const HttpException('❌ Failed. ResponseBody is Empty');
      }

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw HttpException('❌ Lỗi.\nStatusCode: ' +
            response.statusCode.toString() +
            "\nMessage: " +
            (json.decode(utf8.decode(response.bodyBytes))['message'] ?? ""));
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> put({required String url, Object? body}) async {
    try {
      print("body $body");
      print("🔗 PUT URL: $url");
      print("🔗 header : $_authHeader");

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          ..._authHeader,
        },
        body: body,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw TimeoutException(
              'Hết thời gian chờ máy chủ phản hồi. Vui lòng kiểm tra internet và thử lại!');
        },
      );
      print("response $response");

      var responseBody = response.body;

      if (response.body.isEmpty) {
        throw const HttpException('❌ Failed. ResponseBody is Empty');
      }

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw HttpException('❌ Lỗi.\nStatusCode: ' +
            response.statusCode.toString() +
            "\nMessage: " +
            (json.decode(utf8.decode(response.bodyBytes))['message'] ?? ""));
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<dynamic> delete({required String url}) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          ..._authHeader,
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw TimeoutException(
              'Hết thời gian chờ máy chủ phản hồi. Vui lòng kiểm tra internet và thử lại!');
        },
      );

      if (response.body.isEmpty) {
        throw const HttpException('❌ Failed. ResponseBody is Empty');
      }

      if (response.statusCode >= 400) {
        throw HttpException('❌ Không thể xóa mục. \nStatusCode: ' +
            response.statusCode.toString() +
            "\nMessage: " +
            (json.decode(utf8.decode(response.bodyBytes))['message'] ?? ""));
      }

      return json.decode(utf8.decode(response.bodyBytes));
    } catch (error) {
      rethrow;
    }
  }


  static Future<dynamic> multipartRequest({required String method,
    required String url,
    required Map<String, String> fields,
    required List<http.MultipartFile> files}) async {
    //https://pub.dev/documentation/http/latest/http/MultipartRequest-class.html
    try {
      var request = http.MultipartRequest(method, Uri.parse(url))
        ..fields.addAll(fields)
        ..files.addAll(files)
        ..headers.addAll(_authHeader);

      var response = await request.send().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          throw TimeoutException(
              'Hết thời gian chờ máy chủ phản hồi. Vui lòng kiểm tra internet và thử lại!');
        },
      );

      //Get the response from the server
      var responseBodyBytes = await response.stream.toBytes();
      var responseBody = String.fromCharCodes(responseBodyBytes);

      if (responseBody.isEmpty) {
        throw const HttpException('❌ Failed. ResponseBody is Empty');
      }

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(responseBodyBytes));
      } else {
        throw HttpException('❌ Lỗi.\nStatusCode: ' +
            response.statusCode.toString() +
            "\nMessage: " +
            (json.decode(utf8.decode(responseBodyBytes))['message'] ?? ""));
      }
    } catch (error) {
      rethrow;
    }
  }
}
