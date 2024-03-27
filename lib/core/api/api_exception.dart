
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'api_enums.dart';

class ApiException extends Equatable implements Exception{
  final String message;
  const ApiException(this.message);

  @override
  List<Object?> get props => [message,];

  /// 1. on no internet : DioExceptionType.unknown --> ex.error.toString().contains(SocketException)
  /// 2. on invalid url : DioExceptionType.badResponse --> ex.message.contains(404)
  factory ApiException.fromDio(Exception exception){
    String msg = "unknown error occurred";
    if(exception is DioException){
      switch(exception.type){
        case DioExceptionType.connectionTimeout:
          msg+="connection time out"; break;
        case DioExceptionType.receiveTimeout:
          msg+="server took too long to respond"; break;
        case DioExceptionType.sendTimeout:
          msg+="could not send request to server"; break;
        case DioExceptionType.badCertificate:
          msg+="invalid token. login again"; break;
        case DioExceptionType.connectionError:
          msg = "error while connecting to service"; break;
        case DioExceptionType.badResponse:
          if(exception.message?.contains("404") ?? exception.response?.statusCode == 404){
            msg = "invalid request url";
          }else{ msg = "bad response from server"; } break;
        case DioExceptionType.unknown:
          if(exception.error.toString().contains("SocketException")){
            msg = "server unreachable!! check your internet";
          }else{ msg = "unknown error"; } break;
        case DioExceptionType.cancel:
          msg='request cancelled';
          break;
      }
      return ApiException(msg);

    }
    return ApiException(msg);
  }

  factory ApiException.fromParsing(Exception exception){
    return ApiException("parsing Exception: $exception");
  }

  factory ApiException.fromRes(Response response){
    final String msg;
    // check if response.data is a json object,
    // if so then check if it has a message field or error field
    if(response.data is JSON){
      final data = response.data as JSON;
      if(data.containsKey('message')){
        msg = data['message'];
      }else if(data.containsKey('error')){
        msg = data['error'];
      }else{
        msg = "unknown error occurred";
      }
    }else{
      msg = "unknown error occurred";
    }
    return ApiException(msg);
  }
}