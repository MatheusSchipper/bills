import 'package:billsapi_flutter/core/interfaces/mapper_interface.dart';
import 'package:billsapi_flutter/features/bills/data/models/bill_model.dart';
import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';

class BillMapper implements IMapper<Bill, BillModel> {
  @override
  BillModel toModel([Bill bill]) {
    return BillModel(
      name: bill.name,
      originalValue: bill.originalValue,
      dueDate: bill.dueDate,
      paymentDate: bill.paymentDate,
    );
  }
}
