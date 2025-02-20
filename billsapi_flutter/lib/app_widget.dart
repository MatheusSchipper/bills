import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
      initialRoute: Modular.initialRoute,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'),
      ],
      theme: ThemeData(
        fontFamily: 'Titillium',
        primaryColor: Colors.grey,
        accentColor: Colors.black,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 10,
          color: Colors.black,
        ),
      ),
    );
  }
}
