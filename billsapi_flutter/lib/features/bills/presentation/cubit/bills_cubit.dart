import 'package:billsapi_flutter/core/exceptions/failures.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:billsapi_flutter/features/bills/domain/usecases/bills_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';

part 'bills_state.dart';

class BillsCubit extends Cubit<BillsState> {
  BillsCubit() : super(BillsInitialState());

  final IBillsUsecase usecase = Modular.get<IBillsUsecase>();

  void getBills() {
    emit(LoadingBillsState());
    usecase.getBills().then(
      (result) {
        result.fold(
          (failure) {
            emit(FailureWhenGetBillsState());
          },
          (successList) {
            if (successList.isNotEmpty) {
              emit(GetBillsSuccessfullyWithItemsState(billList: successList));
            } else {
              emit(GetBillsSuccessfullyWithoutItemsState());
            }
          },
        );
      },
    );
  }

  void postBill(Bill bill) {
    usecase.postBill(bill).then(
      (result) {
        result.fold(
          (failure) {
            if (failure is NameRequiredFailure) {
              emit(NameRequiredState());
            } else if (failure is InvalidDueDateFailure) {
              emit(InvalidDueDateState());
            } else if (failure is OriginalValueNegativeFailure) {
              emit(OriginalValueNegativeState());
            } else if (failure is DataNotPersistedFailure) {
              emit(DataNotPersistedState());
            } else {
              emit(ErronOnPostBillState(message: failure.message));
            }
          },
          (success) {
            emit(BillPostedSuccessfullyState());
          },
        );
      },
    );
  }
}
