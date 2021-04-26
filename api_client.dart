import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'interceptor/dio_connectivity_request_retrier.dart';
import 'interceptor/retry_interceptor.dart';

class DioApiClient {
  static final String baseUrl = 'https://newsapi.org/v2/';
  static final String apiKey = "a05cd96bc9c242ff9b05f651d90fdba8";
  static Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration.millisecondsPerMinute,
        receiveTimeout: Duration.millisecondsPerMinute,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ),
    );

    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetry: DioConnectivityRequestRetry(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );
  }

  static Future<Response> get({
    @required String url,
    @required Map<String, dynamic> queryParameters,
  }) async {
    return await dio.get(url, queryParameters: queryParameters);
  }
}
