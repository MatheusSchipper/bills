import 'package:billsapi_flutter/app_module.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:billsapi_flutter/features/bills/domain/repositories_interfaces/bills_repository_interface.dart';
import 'package:billsapi_flutter/features/bills/domain/usecases/bills_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MockRepository extends Mock implements IBillsRepository {}

void main() {
  IBillsRepository mockRepository;
  IBillsUsecase usecase;

  setUp(
    () {
      initModule(AppModule(), changeBinds: [
        Bind<IBillsRepository>((i) => MockRepository()),
      ]);
      mockRepository = Modular.get<IBillsRepository>();
      usecase = Modular.get<IBillsUsecase>();
    },
  );

  group(
    'getBills method',
    () {
      var billList = [
        Bill(
          name: 'Globoplay',
          originalValue: 150.0,
          dueDate: DateTime.now(),
          paymentDate: DateTime.now(),
          daysOverdue: 0,
          correctedValue: 150.0,
        ),
      ];
      test(
        'should return a bill list when gets data successfully',
        () async {
          // Arrange
          when(mockRepository.getBills())
              .thenAnswer((_) async => dartz.Right(billList));
          // Act
          final result = await usecase.getBills();
          //Assert
          expect(result, equals(dartz.Right(billList)));
        },
      );
    },
  );

  group(
    'postBill method',
    () {
      var billList = [
        Bill(
          name: 'Globoplay',
          originalValue: 150.0,
          dueDate: DateTime.now(),
          paymentDate: DateTime.now(),
          daysOverdue: 0,
          correctedValue: 150.0,
        ),
      ];
      test(
        'should return true when post data successfully',
        () async {
          // Arrange
          when(mockRepository.postBill(any))
              .thenAnswer((_) async => dartz.Right(true));
          // Act
          final result = await usecase.postBill(billList[0]);
          //Assert
          expect(result, equals(dartz.Right(true)));
        },
      );
    },
  );
}
