import 'package:dio/dio.dart';

class ApiProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.97.215.59:3000",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Dio get dio => _dio;
}
