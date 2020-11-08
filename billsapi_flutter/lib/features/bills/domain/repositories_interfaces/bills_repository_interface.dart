import 'package:billsapi_flutter/core/exceptions/failures.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:dartz/dartz.dart';

abstract class IBillsRepository {
  Future<Either<IFailure, List<Bill>>> getBills();
  Future<Either<IFailure, bool>> postBill(Bill bill);
}
