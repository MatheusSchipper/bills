import 'package:billsapi_flutter/app_widget.dart';
import 'package:billsapi_flutter/features/bills/data/datasources_interfaces/bills_datasource_interface.dart';
import 'package:billsapi_flutter/features/bills/data/mapper/bill_mapper.dart';
import 'package:billsapi_flutter/features/bills/data/repositories/bills_repository.dart';
import 'package:billsapi_flutter/features/bills/domain/repositories_interfaces/bills_repository_interface.dart';
import 'package:billsapi_flutter/features/bills/domain/usecases/bills_usecase.dart';
import 'package:billsapi_flutter/features/bills/presentation/cubit/bills_cubit.dart';
import 'package:billsapi_flutter/features/bills/presentation/pages/bills_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import 'core/interfaces/mapper_interface.dart';
import 'features/bills/external/datasources/bills_datasource.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind<http.Client>((i) => http.Client()),
        Bind<IMapper>((i) => BillMapper()),
        Bind<IBillsDatasource>((i) => BillsDatasource()),
        Bind<IBillsRepository>((i) => BillsRepository()),
        Bind<IBillsUsecase>((i) => BillsUsecase()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          Modular.initialRoute,
          child: (context, args) =>
              BlocProvider(create: (_) => BillsCubit(), child: BillsPage()),
        ),
      ];
}
