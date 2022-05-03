import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/natures_model.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/poke_strat_model.dart';
import '../display_stats_strat_widget.dart';

class DisplayStratStepStatWidgets extends StatefulWidget {
  final PokeStrat pokeStrat;
  final Poke pokeDetails;
  final Natures natures;

  const DisplayStratStepStatWidgets(
      {Key? key,
      required this.pokeStrat,
      required this.pokeDetails,
      required this.natures})
      : super(key: key);

  @override
  State<DisplayStratStepStatWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayStratStepStatWidgetsState(pokeStrat, pokeDetails);
  }
}

class _DisplayStratStepStatWidgetsState
    extends State<DisplayStratStepStatWidgets> {
  PokeStrat? _pokeStrat;
  Poke? _pokeDetails;
  int _level = 50;
  bool _isOpen = false;

  _DisplayStratStepStatWidgetsState(PokeStrat pokeStrat, Poke pokeDetails) {
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
            body: DisplayStatsStratWidgets(
                key: UniqueKey(),
                baseStat: _pokeDetails!.stats,
                poke: _pokeStrat!,
                level: _level,
                natures: widget.natures),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Stats",
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
