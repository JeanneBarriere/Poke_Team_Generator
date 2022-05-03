import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/poke_strat_model.dart';

import '../display_items_widget.dart';

class DisplayStratStepItemWidgets extends StatefulWidget {
  final PokeStrat pokeStrat;

  const DisplayStratStepItemWidgets({Key? key, required this.pokeStrat})
      : super(key: key);

  @override
  State<DisplayStratStepItemWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayStratStepItemWidgetsState(pokeStrat);
  }
}

class _DisplayStratStepItemWidgetsState
    extends State<DisplayStratStepItemWidgets> {
  PokeStrat? _pokeStrat;
  bool _isOpen = false;

  _DisplayStratStepItemWidgetsState(PokeStrat pokeStrat) {
    _pokeStrat = pokeStrat;
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
            body: DisplayItemWidgets(
              key: UniqueKey(),
              poke: _pokeStrat!,
            ),
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  "Items",
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
