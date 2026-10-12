import 'package:dio/dio.dart';
import 'package:stock_management/core/storage/local_storage.dart';

class ApiClient {
  final Dio _dio;
  final LocalStorage _localStorage;

  ApiClient(this._dio, {LocalStorage? localStorage})
      : _localStorage = localStorage ?? LocalStorage() {
    _dio.options.baseUrl = 'https://api.stock-management.com/api/v1';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _localStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _localStorage.clearToken();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}

