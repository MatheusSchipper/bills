import 'package:flutter/material.dart';

class OkSituationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var message = 'Pago em dia!';
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Situação',
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Tooltip(
                  message: message,
                  child: Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.green[900]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
