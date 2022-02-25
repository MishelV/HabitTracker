import 'package:flutter/material.dart';

class ScreenSelectionButton extends StatelessWidget {
  final String routeName;
  final String buttonName;
  final Object? arguments;
  const ScreenSelectionButton(this.routeName, this.buttonName,
      {Key? key, this.arguments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: routeName.isEmpty
            ? null
            : () {
                Navigator.of(context)
                    .pushNamed(routeName, arguments: arguments);
              },
        style: ButtonStyle(
            animationDuration: Duration(seconds: 1),
            shape: MaterialStateProperty.all(StadiumBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.purple[600]),
            padding: MaterialStateProperty.all(EdgeInsets.all(6))),
        child: Text(
          buttonName,
          style: const TextStyle(
              color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
        ));
  }
}
