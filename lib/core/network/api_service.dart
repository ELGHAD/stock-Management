import 'package:dio/dio.dart';
import 'package:stock_management/core/network/api_client.dart';

class ApiService {
  final ApiClient _apiClient;

  ApiService(this._apiClient);

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _apiClient.dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _apiClient.dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _apiClient.dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _apiClient.dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout de connexion. Veuillez réessayer.';
      case DioExceptionType.badResponse:
        return error.response?.data['message'] ?? 'Erreur serveur';
      case DioExceptionType.cancel:
        return 'Requête annulée';
      default:
        return 'Erreur de connexion. Vérifiez votre connexion internet.';
    }
  }
}

