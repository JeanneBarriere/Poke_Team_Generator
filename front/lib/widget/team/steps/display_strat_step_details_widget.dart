import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/poke_strat_model.dart';

import '../display_details_strat_widget.dart';

class DisplayStratStepDetailsWidgets extends StatefulWidget {
  final PokeStrat pokeStrat;
  final Poke pokeDetails;

  const DisplayStratStepDetailsWidgets(
      {Key? key, required this.pokeStrat, required this.pokeDetails})
      : super(key: key);

  @override
  State<DisplayStratStepDetailsWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayStratStepDetailsWidgetsState(pokeStrat, pokeDetails);
  }
}

class _DisplayStratStepDetailsWidgetsState
    extends State<DisplayStratStepDetailsWidgets> {
  PokeStrat? _pokeStrat;
  Poke? _pokeDetails;
  // ignore: unused_field
  int _level = 50;
  bool _isOpen = true;

  _DisplayStratStepDetailsWidgetsState(PokeStrat pokeStrat, Poke pokeDetails) {
    _pokeStrat = pokeStrat;
    _pokeDetails = pokeDetails;
    _level = pokeStrat.level!;
  }

  TextStyle styleTitle = const TextStyle(color: Colors.white70, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        animationDuration: const Duration(milliseconds: 1000),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isOpen,
            body: DisplayDetailsStratWidgets(
              key: UniqueKey(),
              gender: _pokeDetails!.gender!,
              poke: _pokeStrat!,
              setLevel: (value) => {
                setState(() {
                  _level = value;
                })
              },
              abilities: _pokeDetails!.abilities,
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Details",
                  style: styleTitle,
                ),
              );
            },
          ),
        ],
        expansionCallback: (i, isOpen) => setState(() {
              _isOpen = !_isOpen;
            }));
  }
}
