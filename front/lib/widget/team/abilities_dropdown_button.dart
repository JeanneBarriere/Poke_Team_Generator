import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';

class AbilitiesDropDownButton extends StatefulWidget {
  const AbilitiesDropDownButton(
      {Key? key,
      required this.index,
      required this.onPress,
      required this.abilities});

  final String index;
  final Function(String?)? onPress;
  final List<String> abilities;

  @override
  State<AbilitiesDropDownButton> createState() =>
      _AbilitiesDropDownButtonState(index);
}

class _AbilitiesDropDownButtonState extends State<AbilitiesDropDownButton> {
  String index;

  _AbilitiesDropDownButtonState(this.index);

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
          onChanged: this.widget.onPress,
          items: widget.abilities.map<DropdownMenuItem<String>>((String value) {
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
