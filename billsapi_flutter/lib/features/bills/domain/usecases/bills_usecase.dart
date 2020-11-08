import 'package:billsapi_flutter/core/exceptions/failures.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:billsapi_flutter/features/bills/domain/repositories_interfaces/bills_repository_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class IBillsUsecase {
  Future<Either<IFailure, List<Bill>>> getBills();
  Future<Either<IFailure, bool>> postBill(Bill bill);
}

class BillsUsecase implements IBillsUsecase {
  final IBillsRepository repository = Modular.get<IBillsRepository>();
  @override
  Future<Either<IFailure, List<Bill>>> getBills() async {
    return await repository.getBills();
  }

  @override
  Future<Either<IFailure, bool>> postBill(Bill bill) async {
    return await repository.postBill(bill);
  }
}
