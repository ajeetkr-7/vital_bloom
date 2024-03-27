import 'package:dio/dio.dart';
import 'api_enums.dart';
import 'api_exception.dart';

abstract class ApiService{
  Future<Response> request({
    required String endpoint,
    HttpMethod method = HttpMethod.GET,
    JSON? data,
    JSON? headers,
    JSON? queryParameters,
    bool requiresAuthToken = true
  });
  const ApiService();
}


class ApiServiceImpl extends ApiService{
  final Dio dio;

  const ApiServiceImpl({
    required this.dio,
  });

  @override
  Future<Response> request({
    required String endpoint,
    HttpMethod method = HttpMethod.GET,
    JSON? data,
    JSON? headers,
    JSON? queryParameters,
    bool requiresAuthToken = true
  }) async{
    try{
      final response = await dio.request(
        endpoint,
        queryParameters: queryParameters,
        data: data,
        options: Options(
          method: _getHttpMethod(method),
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
          headers: headers,
        ),
      );
      return response;
    } on Exception catch(ex){
      throw ApiException.fromDio(ex);
    }
  }

  String _getHttpMethod(HttpMethod method){
    switch(method){
      case HttpMethod.GET:
        return 'GET';
      case HttpMethod.POST:
        return 'POST';
      case HttpMethod.PATCH:
        return 'PATCH';
      case HttpMethod.DELETE:
        return 'DELETE';
    }
  }

}