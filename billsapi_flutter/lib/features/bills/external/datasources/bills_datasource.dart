import 'dart:convert';

import 'package:billsapi_flutter/core/exceptions/exceptions.dart';
import 'package:billsapi_flutter/core/utils/constants.dart';
import 'package:billsapi_flutter/features/bills/data/datasources_interfaces/bills_datasource_interface.dart';
import 'package:billsapi_flutter/features/bills/data/models/bill_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class BillsDatasource implements IBillsDatasource {
  final http.Client httpClient = Modular.get<http.Client>();
  @override
  Future<List<BillModel>> getBills() async {
    try {
      var result = await httpClient.get(endpointApiUrl);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        return (body as List).map((e) => BillModel.fromJson(e)).toList();
      } else
        throw ServerException(result.statusCode.toString());
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<bool> postBill(BillModel billModel) async {
    try {
      var modelToJson = billModel.toJson();
      var result = await httpClient.post(
        endpointApiUrl,
        body: modelToJson,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (result.statusCode == 200) {
        return true;
      } else {
        Map<String, dynamic> mapError = jsonDecode(result.body);
        String errorMessage = "";
        if (mapError['errors'] as Map<String, dynamic> != null) {
          Map<String, dynamic> errors = mapError['errors'];
          errorMessage = errors.values?.first[0];
        }

        if (errorMessage.contains(nameRequired)) {
          throw NameRequiredException();
        } else if (errorMessage.contains(invalidFormat)) {
          throw FormatException(errorMessage);
        } else if (errorMessage.contains(invalidDueDate)) {
          throw InvalidDueDateException();
        } else if (errorMessage.contains(originalValueMustBePositive)) {
          throw OriginalValueNegativeExpection();
        } else if (errorMessage.contains(dataNotPersisted)) {
          throw DataNotPersistedExpection();
        } else {
          throw ServerException('${result.statusCode}');
        }
      }
    } on Exception {
      rethrow;
    }
  }
}
