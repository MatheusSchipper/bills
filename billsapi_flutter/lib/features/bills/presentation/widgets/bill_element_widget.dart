import 'package:flutter/material.dart';

class BillElementWidget extends StatelessWidget {
  const BillElementWidget({
    Key key,
    @required this.text,
    @required this.textColor,
    @required this.title,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.end,
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
                  message: text,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: textColor),
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
