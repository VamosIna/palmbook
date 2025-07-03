class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({this.message = 'Server error occurred', this.statusCode});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});
}

class NoInternetException implements Exception {
  final String message;

  NoInternetException({this.message = 'No internet connection'});
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException({this.message = 'Bad request'});
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({this.message = 'Unauthorized'});
}

abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => message;
}

// Server-related failures
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(String message, {this.statusCode}) : super(message);

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(exception.message, statusCode: exception.statusCode!);
  }
}

// Cache-related failures
class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(exception.message);
  }
}

// General failures
class GenericFailure extends Failure {
  GenericFailure(String message) : super(message);
}
