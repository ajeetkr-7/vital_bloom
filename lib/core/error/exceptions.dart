

// server exception class for handling server errors
class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
}

// cache exception class for handling cache errors
class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});
}