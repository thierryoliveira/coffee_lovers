final class ServerException extends Error {
  final String message;

  ServerException({this.message = 'Server Exception occurred.'});
}
