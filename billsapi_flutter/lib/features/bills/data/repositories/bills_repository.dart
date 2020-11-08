import 'package:billsapi_flutter/core/exceptions/exceptions.dart';
import 'package:billsapi_flutter/core/interfaces/mapper_interface.dart';
import 'package:billsapi_flutter/features/bills/data/datasources_interfaces/bills_datasource_interface.dart';
import 'package:billsapi_flutter/features/bills/data/models/bill_model.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:billsapi_flutter/core/exceptions/failures.dart';
import 'package:billsapi_flutter/features/bills/domain/repositories_interfaces/bills_repository_interface.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BillsRepository implements IBillsRepository {
  final IBillsDatasource datasource = Modular.get<IBillsDatasource>();
  @override
  Future<Either<IFailure, List<Bill>>> getBills() async {
    try {
      final result = await datasource.getBills();
      return Right(result);
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }

  @override
  Future<Either<IFailure, bool>> postBill(Bill bill) async {
    try {
      var model = Modular.get<IMapper<Bill, BillModel>>().toModel(bill);
      final result = await datasource.postBill(model);
      return Right(result);
    } on NameRequiredException {
      return Left(NameRequiredFailure());
    } on InvalidDueDateException {
      return Left(InvalidDueDateFailure());
    } on OriginalValueNegativeExpection {
      return Left(OriginalValueNegativeFailure());
    } on DataNotPersistedExpection {
      return Left(DataNotPersistedFailure());
    } on ServerException catch (ex) {
      return Left(ServerFailure(message: ex.message));
    }
  }
}
