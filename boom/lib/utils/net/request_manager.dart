import 'dart:developer';

import 'package:dio/dio.dart';

// 枚举类型 - 请求类型
enum HttpType { httpTypeGet, httpTypePost }

class RequestManager {
  // 单例方法
  static Dio? _dioInstance;

  static Dio getRequestManager() {
    _dioInstance ??= Dio();
    return _dioInstance!;
  }

  // 对外抛出方法 - get请求
  static Future<Response> get(String requestUrl,
      {Map<String, dynamic>? queryParameters, String? validate}) async {
    return await _sendHttpRequest(HttpType.httpTypeGet, requestUrl,
        queryParameters: queryParameters, validate: validate);
  }

  // 对外抛出方法 - post请求
  static Future<Response> post(String requestUrl,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      String? validate}) async {
    return await _sendHttpRequest(HttpType.httpTypePost, requestUrl,
        queryParameters: queryParameters, data: data, validate: validate);
  }

  // 私有方法 - 处理get请求、post请求
  static Future _sendHttpRequest(HttpType type, String requestUrl,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      String? validate}) async {
    try {
      switch (type) {
        case HttpType.httpTypeGet:
          return await getRequestManager().get(
            requestUrl,
            queryParameters: queryParameters,
            options: Options(headers: {"validate": validate}),
          );
        case HttpType.httpTypePost:
          return await getRequestManager().post(
            requestUrl,
            queryParameters: queryParameters,
            data: data,
            options: Options(headers: {"validate": validate}),
          );
        default:
          throw Exception('报错了：请求只支持get和post');
      }
    } on DioException catch (e) {
      log("报错:$e");
      return Response(
          data: null, statusCode: 0, requestOptions: RequestOptions());
    }
  }
}
