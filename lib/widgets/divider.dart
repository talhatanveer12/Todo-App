import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(
            child: Divider(
          thickness: 1,
          color: Colors.black,
        )),
        Text(" OR "),
        Expanded(
            child: Divider(
          thickness: 1,
          color: Colors.black,
        )),
      ]),
    );
  }
}
