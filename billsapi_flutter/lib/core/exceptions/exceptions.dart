class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NameRequiredException implements Exception {}

class InvalidDueDateException implements Exception {}

class OriginalValueNegativeExpection implements Exception {}

class DataNotPersistedExpection implements Exception {}
