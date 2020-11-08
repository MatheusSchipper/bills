import 'package:billsapi_flutter/app_module.dart';
import 'package:billsapi_flutter/core/exceptions/exceptions.dart';
import 'package:billsapi_flutter/core/exceptions/failures.dart';
import 'package:billsapi_flutter/core/interfaces/mapper_interface.dart';
import 'package:billsapi_flutter/features/bills/data/datasources_interfaces/bills_datasource_interface.dart';
import 'package:billsapi_flutter/features/bills/data/models/bill_model.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:billsapi_flutter/features/bills/domain/repositories_interfaces/bills_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MockDatasource extends Mock implements IBillsDatasource {}

class MockMapper extends Mock implements IMapper<Bill, BillModel> {}

void main() {
  IBillsDatasource mockDatasource;
  IBillsRepository repository;
  IMapper mockMapper;

  setUp(
    () {
      initModule(AppModule(), changeBinds: [
        Bind<IBillsDatasource>((i) => MockDatasource()),
        Bind<IMapper>((i) => MockMapper()),
      ]);

      mockDatasource = Modular.get<IBillsDatasource>();
      repository = Modular.get<IBillsRepository>();
      mockMapper = Modular.get<IMapper>();
    },
  );

  group(
    'getBills method',
    () {
      var billModelList = [
        BillModel(
          name: 'Globoplay',
          originalValue: 150,
          dueDate: DateTime.now(),
          paymentDate: DateTime.now(),
        ),
        BillModel(
          name: 'Globoplay 2',
          originalValue: 150,
          dueDate: DateTime.now(),
          paymentDate: DateTime.now(),
        ),
        BillModel(
          name: 'Globoplay 3',
          originalValue: 150,
          dueDate: DateTime.now(),
          paymentDate: DateTime.now(),
        ),
      ];
      test(
        'should return ServerFailure when a ServerException occurs',
        () async {
          // Arrange
          when(mockDatasource.getBills())
              .thenThrow(ServerException('Server exception'));
          // Act
          final result = await repository.getBills();
          //Assert
          expect(result,
              equals(dartz.Left(ServerFailure(message: 'Server exception'))));
        },
      );
      test(
        'should return an Bill list when a gets data successfully',
        () async {
          // Arrange
          when(mockDatasource.getBills())
              .thenAnswer((_) async => billModelList);
          // Act
          final result = await repository.getBills();
          //Assert
          expect(result, equals(dartz.Right(billModelList)));
        },
      );
    },
  );
  group(
    'postBill method',
    () {
      var testName = 'Globoplay';
      var testOriginalValue = 150.0;
      var testDueDate = DateTime.now();
      var testPaymentDate = DateTime.now();
      var bill = Bill(
        name: testName,
        originalValue: testOriginalValue,
        dueDate: testDueDate,
        paymentDate: testPaymentDate,
      );
      var billModel = BillModel(
        name: testName,
        originalValue: testOriginalValue,
        dueDate: testDueDate,
        paymentDate: testPaymentDate,
      );

      test(
        'should return NameRequiredFailure when NameRequiredException occurs',
        () async {
          // Arrange
          when(mockMapper.toModel(any)).thenAnswer((_) => billModel);
          when(mockDatasource.postBill(any)).thenThrow(NameRequiredException());
          // Act
          final result = await repository.postBill(bill);
          //Assert
          expect(result, equals(dartz.Left(NameRequiredFailure())));
        },
      );

      test(
        'should return InvalidDueDateFailure when InvalidDueDateException occurs',
        () async {
          // Arrange
          when(mockMapper.toModel(any)).thenAnswer((_) => billModel);
          when(mockDatasource.postBill(any))
              .thenThrow(InvalidDueDateException());
          // Act
          final result = await repository.postBill(bill);
          //Assert
          expect(result, equals(dartz.Left(InvalidDueDateFailure())));
        },
      );

      test(
        'should return OriginalValueNegativeFailure when OriginalValueNegativeExpection occurs',
        () async {
          // Arrange
          when(mockMapper.toModel(any)).thenAnswer((_) => billModel);
          when(mockDatasource.postBill(any))
              .thenThrow(OriginalValueNegativeExpection());
          // Act
          final result = await repository.postBill(bill);
          //Assert
          expect(result, equals(dartz.Left(OriginalValueNegativeFailure())));
        },
      );

      test(
        'should return DataNotPersistedFailure when DataNotPersistedExpection occurs',
        () async {
          // Arrange
          when(mockMapper.toModel(any)).thenAnswer((_) => billModel);
          when(mockDatasource.postBill(any))
              .thenThrow(DataNotPersistedExpection());
          // Act
          final result = await repository.postBill(bill);
          //Assert
          expect(result, equals(dartz.Left(DataNotPersistedFailure())));
        },
      );

      test(
        'should return ServerFailure when ServerException occurs',
        () async {
          // Arrange
          when(mockMapper.toModel(any)).thenAnswer((_) => billModel);
          when(mockDatasource.postBill(any))
              .thenThrow(ServerException("Server error"));
          // Act
          final result = await repository.postBill(bill);
          //Assert
          expect(result,
              equals(dartz.Left(ServerFailure(message: "Server error"))));
        },
      );

      test(
        'should return true when post data successfully',
        () async {
          // Arrange
          when(mockMapper.toModel(any)).thenAnswer((_) => billModel);
          when(mockDatasource.postBill(any)).thenAnswer((_) async => true);
          // Act
          final result = await repository.postBill(bill);
          //Assert
          expect(result, equals(dartz.Right(true)));
        },
      );
    },
  );
}
