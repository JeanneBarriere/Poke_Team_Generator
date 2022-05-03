import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/poke_strat_model.dart';
import 'package:front/widget/team/display_moves_strat_widget.dart';

class DisplayStratStepMovesWidgets extends StatefulWidget {
  final PokeStrat pokeStrat;
  final Poke pokeDetails;

  const DisplayStratStepMovesWidgets(
      {Key? key, required this.pokeStrat, required this.pokeDetails})
      : super(key: key);

  @override
  State<DisplayStratStepMovesWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayStratStepMovesWidgetsState(pokeStrat, pokeDetails);
  }
}

class _DisplayStratStepMovesWidgetsState
    extends State<DisplayStratStepMovesWidgets> {
  PokeStrat? _pokeStrat;
  Poke? _pokeDetails;
  int _level = 50;
  bool _isOpen = false;

  _DisplayStratStepMovesWidgetsState(PokeStrat pokeStrat, Poke pokeDetails) {
    _pokeStrat = pokeStrat;
    _pokeDetails = pokeDetails;
    _level = pokeStrat.level!;
  }

  TextStyle styleTitle = const TextStyle(color: Colors.white70, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        animationDuration: const Duration(milliseconds: 2000),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isOpen,
            body: DisplayMovesStratWidgets(
              key: UniqueKey(),
              baseStat: _pokeDetails!.stats,
              poke: _pokeStrat!,
              level: _level,
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Moves",
                  style: styleTitle,
                ),
              );
            },
          )
        ],
        expansionCallback: (i, isOpen) => setState(() {
              _isOpen = !_isOpen;
            }));
  }
}
