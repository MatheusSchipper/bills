import 'package:meta/meta.dart';

class Bill {
  String name;
  double originalValue;
  DateTime dueDate;
  DateTime paymentDate;
  int daysOverdue;
  double correctedValue;

  Bill({
    @required this.name,
    @required this.originalValue,
    @required this.dueDate,
    @required this.paymentDate,
    this.daysOverdue,
    this.correctedValue,
  });
}
