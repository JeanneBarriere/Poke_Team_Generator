import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/nature_model.dart';
import 'package:front/model/natures_model.dart';
import 'package:front/model/poke_strat_model.dart';

class NaturesDropDownButton extends StatefulWidget {
  NaturesDropDownButton(
      {Key? key,
      required this.poke,
      required this.natures,
      required this.currentNature});

  final PokeStrat poke;
  final Natures natures;
  Nature currentNature;

  @override
  State<NaturesDropDownButton> createState() =>
      _NaturesDropDownButtonState(natures);
}

class _NaturesDropDownButtonState extends State<NaturesDropDownButton> {
  late Nature natureIndex;

  _NaturesDropDownButtonState(Natures natures) {
    natureIndex = natures.natures!.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Palette.kToDark.shade400,
        ),
        child: DropdownButton<Nature>(
          value: natureIndex,
          icon: const Icon(Icons.arrow_drop_down_outlined,
              color: Color(0xff733024)),
          elevation: 0,
          style: const TextStyle(),
          underline: Container(
            height: 1.5,
            color: Palette.kToDark.shade400,
          ),
          onChanged: (newValue) => {
            setState(() => {
                  natureIndex = newValue!,
                  widget.poke.nature = newValue!.name,
                  widget.currentNature = newValue
                })
          },
          items: widget.natures.natures!
              .map<DropdownMenuItem<Nature>>((Nature value) {
            return DropdownMenuItem<Nature>(
              value: value,
              child: Text(value.name),
              // Text("+" + value.increasedStat!),
              // Text("-" + value.decreasedStat!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
