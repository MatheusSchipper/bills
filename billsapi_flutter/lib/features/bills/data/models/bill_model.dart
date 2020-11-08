import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:billsapi_flutter/core/interfaces/model_interface.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:uuid/uuid.dart';

class BillModel extends Bill implements IModel {
  BillModel({
    @required String name,
    @required double originalValue,
    @required DateTime dueDate,
    @required DateTime paymentDate,
    int daysOverdue,
    double correctedValue,
  }) : super(
          name: name,
          originalValue: originalValue,
          dueDate: dueDate,
          paymentDate: paymentDate,
          daysOverdue: daysOverdue,
          correctedValue: correctedValue,
        );

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      name: json['name'],
      originalValue: (json['originalValue'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      paymentDate: DateTime.parse(json['paymentDate']),
      correctedValue: (json['correctedValue'] as num).toDouble(),
      daysOverdue: (json['daysOverdue'] as num).toInt(),
    );
  }

  @override
  String toJson() {
    var map = <String, dynamic>{
      'id': Uuid().v1(),
      'name': name,
      'originalValue': originalValue,
      'dueDate': dueDate.toIso8601String(),
      'paymentDate': paymentDate.toIso8601String(),
    };
    return jsonEncode(map);
  }
}
