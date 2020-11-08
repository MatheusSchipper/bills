import 'package:equatable/equatable.dart';

abstract class IFailure extends Equatable {
  final String message;

  IFailure({this.message});
}

class ServerFailure extends IFailure {
  ServerFailure({String message}) : super(message: message);
  @override
  List<Object> get props => [message];
}

class NameRequiredFailure extends IFailure {
  @override
  List<Object> get props => [];
}

class InvalidDueDateFailure extends IFailure {
  @override
  List<Object> get props => [];
}

class OriginalValueNegativeFailure extends IFailure {
  @override
  List<Object> get props => [];
}

class DataNotPersistedFailure extends IFailure {
  @override
  List<Object> get props => [];
}
