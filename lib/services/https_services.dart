import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:coincap_app/models/app_config.dart';

class HttpsServices {
  final Dio _dio = Dio();
  late String _baseurls;

  HttpsServices() {
    _dio.options.baseUrl = GetIt.instance<AppConfig>().COIN_API_BASE_URL;
    _baseurls = _dio.options.baseUrl;
  }

  Future<dynamic> get(String _path) async {
    try {
      if (_path.isEmpty) throw Exception('Path cannot be empty');

      final fullPath = !_path.startsWith('/') ? _path : _path.substring(1);

      print('Making GET request to: $_baseurls$fullPath');

      final response = await _dio.get(fullPath);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in get request: $e');
      throw Exception('Error in get request: $e');
    }
  }
}
