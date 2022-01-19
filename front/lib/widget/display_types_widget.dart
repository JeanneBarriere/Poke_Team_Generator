import 'package:flutter/material.dart';

class DisplayTypesWidgets extends StatelessWidget {
  final List<String?> strings;
  final double size;

  const DisplayTypesWidgets(
      {Key? key, required this.strings, required this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
        children: strings
            .map((item) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset("assets/images/types/$item.png",
                    height: size, width: size)))
            .toList());
  }
}
