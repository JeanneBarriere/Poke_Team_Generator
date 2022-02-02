import 'package:flutter/material.dart';
import 'package:front/widget/display_iconsmall_widget.dart';

class DisplayIconSmallBannerWidgets extends StatelessWidget {
  final List<String?> listPoke;

  const DisplayIconSmallBannerWidgets(
      {Key? key,
      required this.listPoke,
      required this.onPress,
      required this.current})
      : super(key: key);

  final Function(int? string) onPress;
  final int? current;
  @override
  Widget build(BuildContext context) {
    _poke() {
      var children = <Widget>[];
      if (listPoke != []) {
        for (var poke in listPoke) {
          print("lenght");
          print(listPoke);
          children.add(GestureDetector(
            onTap: () async {
              onPress(listPoke.indexOf(poke));
            },
            child: Container(
              decoration: BoxDecoration(
                border: current == listPoke.indexOf(poke)
                    ? Border.all(
                        color: Colors.red[700]!,
                      )
                    : null,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: DisplayIconSmallWidgets(name: poke!.toLowerCase()),
              ),
            ),
          ));
        }
      }

      for (var i = (6 - listPoke.length); i > 0; i--) {
        children.add(GestureDetector(
          onTap: () async {
            onPress(null);
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
                height: 55,
                width: 55,
                decoration: const BoxDecoration(
                    color: Color(0xFF343442),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: null),
          ),
        ));
      }
      return children;
    }

    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _poke()));
  }
}
