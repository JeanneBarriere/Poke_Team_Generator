import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/poke_strat_model.dart';

import 'display_details_strat_widget.dart';
import 'display_stats_strat_widget.dart';

class DisplayStratStepWidgets extends StatefulWidget {
  final PokeStrat pokeStrat;
  final Poke pokeDetails;

  const DisplayStratStepWidgets({
    Key? key,
    required this.pokeStrat,
    required this.pokeDetails,
  }) : super(key: key);

  @override
  State<DisplayStratStepWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayStratStepWidgetsState(pokeStrat, pokeDetails);
  }
}

class _DisplayStratStepWidgetsState extends State<DisplayStratStepWidgets> {
  PokeStrat? _pokeStrat;
  final List<bool> _isOpen = [true, false, false];
  Poke? _pokeDetails;

  _DisplayStratStepWidgetsState(PokeStrat pokeStrat, Poke pokeDetails) {
    _pokeStrat = pokeStrat;
    _pokeDetails = pokeDetails;
  }

  TextStyle styleTitle = const TextStyle(color: Colors.white70, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
        animationDuration: const Duration(milliseconds: 800),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isOpen[0],
            body: DisplayDetailsStratWidgets(
              key: UniqueKey(),
              gender: _pokeDetails!.gender!,
              poke: _pokeStrat!,
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
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isOpen[1],
            body: DisplayStatsStratWidgets(
              key: UniqueKey(),
              baseStat: _pokeDetails!.stats,
              poke: _pokeStrat!,
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Stats",
                  style: styleTitle,
                ),
              );
            },
          ),
        ],
        expansionCallback: (i, isOpen) => setState(() {
              _isOpen[i] = !isOpen;
            }));
  }
}
