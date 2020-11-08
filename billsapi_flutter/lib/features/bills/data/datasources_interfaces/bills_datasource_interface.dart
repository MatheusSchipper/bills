import 'package:billsapi_flutter/features/bills/data/models/bill_model.dart';

abstract class IBillsDatasource {
  Future<List<BillModel>> getBills();
  Future<bool> postBill(BillModel billModel);
}
