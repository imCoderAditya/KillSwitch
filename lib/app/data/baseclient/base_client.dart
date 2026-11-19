import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../../services/storage_service.dart';
import '../endpoint/end_point.dart';

/// Logs every outgoing Dio request in the exact curl format for Postman,
/// and prints the response JSON right below it.
class CurlInterceptor extends Interceptor {
  // Store curl per-request so we can print it alongside the response
  final _curlMap = <String, String>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final lines = <String>[];

      // First line: curl --location 'URL'
      lines.add("curl --location '${options.uri}'");

      // Each header on its own line
      options.headers.forEach((key, value) {
        lines.add("--header '$key: $value'");
      });

      // Body (POST/PUT/PATCH)
      final data = options.data;
      if (data != null) {
        String body;
        if (data is Map || data is List) {
          body = jsonEncode(data);
        } else {
          body = data.toString();
        }
        lines.add("--data-raw '${body.replaceAll("'", "\\'")}'");
      }

      final curlCommand = lines.join(' \\\n');
      // Cache so onResponse can pair it
      _curlMap[options.hashCode.toString()] = curlCommand;

      log(
        '\n┌─ REQUEST ───────────────────────────────────────────────────────\n'
        '$curlCommand\n'
        '└─────────────────────────────────────────────────────────────────',
        name: 'CURL',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final key = response.requestOptions.hashCode.toString();
      final curl = _curlMap.remove(key) ?? '';

      // Pretty-print JSON if possible
      String prettyBody;
      try {
        final dynamic decoded = response.data is String
            ? jsonDecode(response.data as String)
            : response.data;
        prettyBody = const JsonEncoder.withIndent('  ').convert(decoded);
      } catch (_) {
        prettyBody = response.data?.toString() ?? '(empty)';
      }

      log(
        '\n┌─ RESPONSE  ${response.statusCode} ────────────────────────────────────────────\n'
        '│ URL : ${response.requestOptions.uri}\n'
        '│ curl: $curl\n'
        '├─ BODY ──────────────────────────────────────────────────────────\n'
        '$prettyBody\n'
        '└─────────────────────────────────────────────────────────────────',
        name: 'CURL',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final key = err.requestOptions.hashCode.toString();
      _curlMap.remove(key);

      String errBody;
      try {
        final dynamic decoded = err.response?.data is String
            ? jsonDecode(err.response?.data as String)
            : err.response?.data;
        errBody = const JsonEncoder.withIndent('  ').convert(decoded);
      } catch (_) {
        errBody = err.response?.data?.toString() ?? err.message ?? 'Unknown error';
      }

      log(
        '\n┌─ ERROR  ${err.response?.statusCode ?? 'NO STATUS'} ────────────────────────────────────────────────\n'
        '│ URL  : ${err.requestOptions.uri}\n'
        '│ Type : ${err.type}\n'
        '├─ BODY ──────────────────────────────────────────────────────────\n'
        '$errBody\n'
        '└─────────────────────────────────────────────────────────────────',
        name: 'CURL',
      );
    }
    handler.next(err);
  }
}


// ignore_for_file: constant_identifier_names
const bool kDebugMode = bool.fromEnvironment('dart.vm.product') == false;

class BaseClient {
  static const String baseUrl = EndPoint.endPoint;

  late final Dio _dio;

  BaseClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = StorageService.to.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          StorageService.to.clearToken();
        }
        return handler.next(e);
      },
    ));

    // ✅ Curl logger — runs AFTER auth header is injected
    // (also prints response + errors — LogInterceptor removed to avoid duplication)
    _dio.interceptors.add(CurlInterceptor());

  }

  Dio get dio => _dio;
}
