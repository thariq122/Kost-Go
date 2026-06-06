import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static const Duration _timeout = Duration(seconds: 15);

  /// GET request, return decoded body atau throw exception
  static Future<Map<String, dynamic>> get(String url,
      {Map<String, String>? queryParams}) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    try {
      final response = await http.get(uri).timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on HttpException {
      throw Exception('Server tidak dapat dijangkau');
    }
  }

  /// POST request dengan JSON body
  static Future<Map<String, dynamic>> post(String url,
      {required Map<String, dynamic> body}) async {
    final uri = Uri.parse(url);
    try {
      final response = await http
          .post(uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on HttpException {
      throw Exception('Server tidak dapat dijangkau');
    }
  }

  /// POST multipart — untuk upload file (bukti transfer)
  static Future<Map<String, dynamic>> postMultipart(
    String url, {
    required Map<String, String> fields,
    File? file,
    String fileField = 'bukti_transfer',
  }) async {
    final uri = Uri.parse(url);
    try {
      final request = http.MultipartRequest('POST', uri);
      request.fields.addAll(fields);

      if (file != null) {
        request.files
            .add(await http.MultipartFile.fromPath(fileField, file.path));
      }

      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on HttpException {
      throw Exception('Server tidak dapat dijangkau');
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    // Strip BOM (\uFEFF) dan whitespace sebelum decode
    final body = response.body.replaceAll('\uFEFF', '').trim();
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'Terjadi kesalahan server');
    }
  }

  /// Expose decode untuk dipakai booking_service
  static Map<String, dynamic> decodeResponse(http.Response response) =>
      _handleResponse(response);
}
