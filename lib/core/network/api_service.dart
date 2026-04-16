import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> callEndpoint({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method.toUpperCase()),
      );
      
      // Assume API returns a JSON map
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {"data": response.data};
    } on DioException catch (e) {
      throw Exception('API call failed: ${e.message}');
    }
  }
}
