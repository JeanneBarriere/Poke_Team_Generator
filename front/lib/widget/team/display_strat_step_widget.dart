import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/natures_model.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/poke_strat_model.dart';
import 'package:front/widget/team/steps/display_strat_step_details_widget.dart';
import 'package:front/widget/team/steps/display_strat_step_item_widget.dart';
import 'package:front/widget/team/steps/display_strat_step_moves_widget.dart';
import 'package:front/widget/team/steps/display_strat_step_stat_widget.dart';

class DisplayStratStepWidgets extends StatefulWidget {
  final PokeStrat pokeStrat;
  final Poke pokeDetails;
  final Natures natures;

  const DisplayStratStepWidgets(
      {Key? key,
      required this.pokeStrat,
      required this.pokeDetails,
      required this.natures})
      : super(key: key);

  @override
  State<DisplayStratStepWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayStratStepWidgetsState(pokeStrat, pokeDetails);
  }
}

class _DisplayStratStepWidgetsState extends State<DisplayStratStepWidgets> {
  PokeStrat? _pokeStrat;
  Poke? _pokeDetails;

  _DisplayStratStepWidgetsState(PokeStrat pokeStrat, Poke pokeDetails) {
    _pokeStrat = pokeStrat;
    _pokeDetails = pokeDetails;
  }

  TextStyle styleTitle = const TextStyle(color: Colors.white70, fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DisplayStratStepDetailsWidgets(
            pokeStrat: _pokeStrat!, pokeDetails: _pokeDetails!),
        DisplayStratStepStatWidgets(
            pokeStrat: _pokeStrat!,
            pokeDetails: _pokeDetails!,
            natures: widget.natures),
        DisplayStratStepMovesWidgets(
            pokeStrat: _pokeStrat!, pokeDetails: _pokeDetails!),
        DisplayStratStepItemWidgets(pokeStrat: _pokeStrat!)
      ],
    );
  }
}
