part of 'bills_cubit.dart';

abstract class BillsState extends Equatable {
  const BillsState();

  @override
  List<Object> get props => [];
}

class BillsInitialState extends BillsState {}

class LoadingBillsState extends BillsState {}

class GetBillsSuccessfullyWithItemsState extends BillsState {
  final List<Bill> billList;

  GetBillsSuccessfullyWithItemsState({@required this.billList});
}

class GetBillsSuccessfullyWithoutItemsState extends BillsState {}

class FailureWhenGetBillsState extends BillsState {}

class BillPostedSuccessfullyState extends BillsState {}

class ErronOnPostBillState extends BillsState {
  final String message;

  ErronOnPostBillState({@required this.message});
}

class NameRequiredState extends BillsState {}

class InvalidDueDateState extends BillsState {}

class OriginalValueNegativeState extends BillsState {}

class DataNotPersistedState extends BillsState {}
