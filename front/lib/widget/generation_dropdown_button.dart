import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';

class GenerationDropDownButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const GenerationDropDownButton(
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
            'Generation 1',
            'Generation 2',
            'Generation 3',
            'Generation 4',
            'Generation 5',
            'Generation 6',
            'Generation 7',
            'Generation 8'
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
