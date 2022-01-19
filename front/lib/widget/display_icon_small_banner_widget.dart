import 'package:flutter/material.dart';
import 'package:front/widget/display_iconsmall_widget.dart';

class DisplayIconSmallBannerWidgets extends StatelessWidget {
  final List<String?> listPoke;

  const DisplayIconSmallBannerWidgets({Key? key, required this.listPoke})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (var poke in listPoke) {
      children.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: DisplayIconSmallWidgets(name: poke!.toLowerCase()),
      ));
    }

    for (var i = (6 - listPoke.length); i > 0; i--) {
      children.add(Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
            height: 55,
            width: 55,
            decoration: const BoxDecoration(
                color: const Color(0xFF343442),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: null),
      ));
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children));
  }
}
