import 'package:billsapi_flutter/features/bills/domain/entities/bill.dart';
import 'package:billsapi_flutter/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:billsapi_flutter/features/bills/presentation/widgets/bill_element_widget.dart';
import 'package:billsapi_flutter/features/bills/presentation/widgets/ok_situation_widget.dart';
import 'package:billsapi_flutter/features/bills/presentation/widgets/text_form_field_widget.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  int billsListLength = 0;
  TextEditingController nameController = TextEditingController();
  MoneyMaskedTextController valueController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    precision: 2,
    leftSymbol: 'R\$',
  );
  TextEditingController dueDateController = TextEditingController(text: '');
  TextEditingController paymentDateController = TextEditingController(text: '');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dueDateString = '';
  String paymentDateString = '';

  @override
  void initState() {
    context.read<BillsCubit>().getBills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciador de contas',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
      ),
      body: Builder(
        builder: (context) => Row(
          children: [
            BlocConsumer<BillsCubit, BillsState>(listener: (context, state) {
              Color color = Colors.red;
              String text = '';
              if (state is BillPostedSuccessfullyState) {
                text = 'Conta salva!';
                color = Colors.green[600];
                resetFields();
              } else if (state is NameRequiredState) {
                text = 'Nome é obrigatório!';
              } else if (state is InvalidDueDateState) {
                text =
                    'A data de vencimento não pode ser anterior ao ano atual';
              } else if (state is OriginalValueNegativeState) {
                text = 'Valor da conta não pode ser negativo';
              } else if (state is DataNotPersistedState) {
                text = 'Dados não salvos. Tente novamente mais tarde';
              } else {
                var errorState = state as ErronOnPostBillState;
                text = errorState.message;
              }

              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(text),
                backgroundColor: color,
              ));
            }, builder: (context, state) {
              return Expanded(
                flex: 1,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: constraints.maxHeight * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Card(
                        color: Colors.grey[300],
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dados da conta',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                TextFormFieldWidget(
                                  controller: nameController,
                                  label: 'Nome',
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Nome é obrigatório!';
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                                TextFormFieldWidget(
                                  controller: valueController,
                                  label: 'Valor da conta',
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return 'Valor é obrigatório!';
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DateTimePicker(
                                    calendarTitle: 'Vencimento ',
                                    cancelText: 'Cancelar',
                                    confirmText: 'Confirmar',
                                    type: DateTimePickerType.date,
                                    dateMask: 'dd/MM/yyyy',
                                    initialValue: DateTime.now().toString(),
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate:
                                        DateTime(DateTime.now().year, 12, 31),
                                    icon: Icon(Icons.calendar_today),
                                    dateLabelText: 'Data de vencimento',
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Data de vencimento é obrigatória!';
                                      } else {
                                        if (DateTime.parse(value).year <
                                            DateTime.now().year) {
                                          return 'A data de vencimento não pode ser anterior ao ano atual';
                                        } else {
                                          setState(() {
                                            dueDateString = value;
                                          });
                                          return null;
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      labelText: 'Data de vencimento',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DateTimePicker(
                                    calendarTitle: 'Pagamento ',
                                    cancelText: 'Cancelar',
                                    confirmText: 'Confirmar',
                                    type: DateTimePickerType.date,
                                    dateMask: 'dd/MM/yyyy',
                                    initialValue: DateTime.now().toString(),
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate:
                                        DateTime(DateTime.now().year, 12, 31),
                                    icon: Icon(Icons.calendar_today),
                                    dateLabelText: 'Data de pagamento',
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Data de pagamento é obrigatória!';
                                      else {
                                        setState(() {
                                          paymentDateString = value;
                                        });
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      labelText: 'Data de Pagamento',
                                    ),
                                  ),
                                ),
                                Container(
                                  height: constraints.maxHeight * 0.1,
                                  width: constraints.maxWidth * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        sendInformation();
                                      }
                                    },
                                    child: Text(
                                      'Salvar',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
            Expanded(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: BlocConsumer<BillsCubit, BillsState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is GetBillsSuccessfullyWithItemsState) {
                          return ListView.builder(
                            itemCount: state.billList.length,
                            itemBuilder: (context, index) {
                              var bill = state.billList[index];
                              return buildListItem(constraints, bill);
                            },
                          );
                        } else if (state is LoadingBillsState) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                          );
                        } else if (state is FailureWhenGetBillsState) {
                          return Center(
                            child: Text('Erro ao buscar contas'),
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Nenhuma conta a pagar',
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendInformation() {
    Bill bill = Bill(
      name: nameController.text,
      dueDate: DateTime.parse(dueDateString),
      paymentDate: DateTime.parse(paymentDateString),
      originalValue: valueController.numberValue,
    );
    context.read<BillsCubit>().postBill(bill);
  }

  void resetFields() {
    _formKey.currentState.reset();
    nameController.clear();
    valueController.clear();

    context.read<BillsCubit>().getBills();
  }

  Widget buildListItem(BoxConstraints constraints, Bill bill) {
    bool payAfter = bill.daysOverdue > 0;
    String paymentDateFormatted =
        DateFormat('dd/MM/yyyy').format(bill.paymentDate);
    String dueDateFormatted = DateFormat('dd/MM/yyyy').format(bill.dueDate);

    var currencyFormat = NumberFormat.currency(
      locale: 'pt-BR',
      decimalDigits: 2,
      symbol: 'R\$',
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          width: constraints.maxWidth,
          height: constraints.maxHeight * 0.2,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BillElementWidget(
                  title: 'Valor original',
                  text: currencyFormat.format(bill.originalValue),
                  textColor: Colors.blue[600],
                ),
                BillElementWidget(
                  title: 'Nome',
                  text: bill.name,
                  textColor: Colors.blue[600],
                ),
                BillElementWidget(
                  title: 'Vencimento',
                  text: dueDateFormatted,
                  textColor: Colors.blue[600],
                ),
                BillElementWidget(
                  title: 'Pagamento',
                  text: paymentDateFormatted,
                  textColor: payAfter ? Colors.red[800] : Colors.green[800],
                ),
                Visibility(
                  child: BillElementWidget(
                    text: bill.daysOverdue.toString(),
                    textColor: Colors.red[800],
                    title: 'Dias em atraso',
                  ),
                  visible: payAfter,
                ),
                Visibility(
                  child: BillElementWidget(
                    text: currencyFormat.format(bill.correctedValue),
                    textColor: Colors.red[800],
                    title: 'Valor corrigido',
                  ),
                  visible: payAfter,
                ),
                Visibility(
                  child: OkSituationWidget(),
                  visible: !payAfter,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
