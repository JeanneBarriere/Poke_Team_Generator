import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';

class TypeDropDownButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TypeDropDownButton(
      {Key? key, required this.index, required this.onPress});

  final String index;
  final Function(String?)? onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Palette.kToDark.shade400,
        ),
        child: DropdownButton<String>(
          value: index,
          icon: const Icon(Icons.arrow_drop_down_outlined,
              color: Color(0xff733024)),
          elevation: 0,
          style: const TextStyle(),
          underline: Container(
            height: 1.5,
            color: Palette.kToDark.shade400,
          ),
          onChanged: onPress,
          items: <String>[
            "Type",
            "Bug",
            "Dark",
            "Dragon",
            "Electric",
            "Fairy",
            "Fighting",
            "Fairy",
            "Fire",
            "Flying",
            "Ghost",
            "Grass",
            "Ground",
            "Ice",
            "Normal",
            "Poison",
            "Psychic",
            "Rock",
            "Steel",
            "Water",
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
