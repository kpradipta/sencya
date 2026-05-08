class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'A server error occurred'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {}
