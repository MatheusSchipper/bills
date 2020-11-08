import 'package:billsapi_flutter/app_module.dart';
import 'package:billsapi_flutter/core/exceptions/exceptions.dart';
import 'package:billsapi_flutter/features/bills/data/datasources_interfaces/bills_datasource_interface.dart';
import 'package:billsapi_flutter/features/bills/data/models/bill_model.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  http.Client mockHttpClient;
  IBillsDatasource datasource;

  setUp(
    () {
      initModule(AppModule(), changeBinds: [
        Bind<http.Client>((i) => MockHttpClient()),
      ]);
      mockHttpClient = Modular.get<http.Client>();
      datasource = Modular.get<IBillsDatasource>();
    },
  );

  group(
    'getBills method',
    () {
      test(
        'should return an ServerException when status code is 400',
        () async {
          // Arrange
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response('', 400),
          );
          //Assert
          expect(() async {
            // Act
            await datasource.getBills();
          }, throwsA(TypeMatcher<ServerException>()));
        },
      );
      test(
        'should return an ServerException when request fails',
        () async {
          // Arrange
          when(mockHttpClient.get(any)).thenThrow(
            ServerException("Server error"),
          );
          //Assert
          expect(() async {
            // Act
            await datasource.getBills();
          }, throwsA(TypeMatcher<ServerException>()));
        },
      );
      test(
        'should return an List of BillModel when status code is 200',
        () async {
          // Arrange
          when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(fixture('bills.json'), 200),
          );
          // Act
          final result = await datasource.getBills();
          //Assert
          expect(result, isA<List<BillModel>>());
          expect(result.length, 3);
        },
      );
    },
  );

  group(
    'postBills method',
    () {
      var testName = 'Globoplay';
      var testOriginalValue = 150.0;
      var testInvalidOriginalValue = -150.0;
      var testDueDate = DateTime.now();
      var testInvalidDueDate = DateTime(DateTime.now().year - 1, 1, 1);
      var testPaymentDate = DateTime.now();
      test(
        'should return a FieldRequiredException when model doesn\'t have name',
        () async {
          // Arrange
          when(mockHttpClient.post(any,
                  body: anyNamed('body'), headers: anyNamed('headers')))
              .thenAnswer((_) async =>
                  http.Response(fixture('name_required_exception.json'), 400));
          var testBillModel = BillModel(
            name: null,
            originalValue: testOriginalValue,
            dueDate: testDueDate,
            paymentDate: testPaymentDate,
          );

          //Assert
          expect(() async {
            // Act
            await datasource.postBill(testBillModel);
          }, throwsA(TypeMatcher<NameRequiredException>()));
        },
      );

      test(
        'should return an OriginalValueNegativeExpection when model has negative originalValue',
        () async {
          // Arrange
          when(mockHttpClient.post(any,
                  body: anyNamed('body'), headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
                  fixture('negative_original_value_exception.json'), 400));
          var testBillModel = BillModel(
            name: testName,
            originalValue: testInvalidOriginalValue,
            dueDate: testDueDate,
            paymentDate: testPaymentDate,
          );
          //Assert
          expect(() async {
            // Act
            await datasource.postBill(testBillModel);
          }, throwsA(TypeMatcher<OriginalValueNegativeExpection>()));
        },
      );

      test(
        'should return an InvalidDueDateException when dueDate is previous than current year',
        () async {
          // Arrange
          when(mockHttpClient.post(any,
                  body: anyNamed('body'), headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
                  fixture('invalid_due_date_exception.json'), 400));
          var testBillModel = BillModel(
            name: testName,
            originalValue: testOriginalValue,
            dueDate: testInvalidDueDate,
            paymentDate: testPaymentDate,
          );
          //Assert
          expect(() async {
            // Act
            await datasource.postBill(testBillModel);
          }, throwsA(TypeMatcher<InvalidDueDateException>()));
        },
      );

      test(
        'should return an DataNotPersistedExpection when data is not persisted on remote database',
        () async {
          //Arrange
          when(mockHttpClient.post(any,
                  body: anyNamed('body'), headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(
                  fixture('data_not_persisted_exception.json'), 400));
          var testBillModel = BillModel(
            name: testName,
            originalValue: testOriginalValue,
            dueDate: testDueDate,
            paymentDate: testPaymentDate,
          );
          //Assert
          expect(() async {
            // Act
            await datasource.postBill(testBillModel);
          }, throwsA(TypeMatcher<DataNotPersistedExpection>()));
        },
      );

      test(
        'should return an FormatException when model has properties with invalid type',
        () async {
          //Arrange
          when(mockHttpClient.post(any,
                  body: anyNamed('body'), headers: anyNamed('headers')))
              .thenAnswer((_) async =>
                  http.Response(fixture('invalid_format_exception.json'), 400));
          var testBillModel = BillModel(
            name: testName,
            originalValue: testOriginalValue,
            dueDate: testDueDate,
            paymentDate: testPaymentDate,
          );
          //Assert
          expect(() async {
            // Act
            await datasource.postBill(testBillModel);
          }, throwsA(TypeMatcher<FormatException>()));
        },
      );

      test(
        'should return true when post data successfully',
        () async {
          //Arrange
          when(mockHttpClient.post(any,
                  body: anyNamed('body'), headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response("Ok", 200));
          var testBillModel = BillModel(
            name: testName,
            originalValue: testOriginalValue,
            dueDate: testDueDate,
            paymentDate: testPaymentDate,
          );

          // Act
          final result = await datasource.postBill(testBillModel);
          //Assert
          expect(result, true);
        },
      );
    },
  );
}
