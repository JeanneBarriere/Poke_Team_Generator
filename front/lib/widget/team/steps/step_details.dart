// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:front/model/natures_model.dart';
// import 'package:front/model/poke_model.dart';
// import 'package:front/model/poke_strat_model.dart';
// import 'package:front/widget/team/display_items_widget.dart';
// import 'package:front/widget/team/display_moves_strat_widget.dart';

// import '../display_details_strat_widget.dart';
// import '../display_stats_strat_widget.dart';

// class StepDetails extends StatefulWidget {
//   final PokeStrat pokeStrat;
//   final Poke pokeDetails;
//   final Natures natures;

//   const StepDetails(
//       {Key? key,
//       required this.pokeStrat,
//       required this.pokeDetails,
//       required this.natures})
//       : super(key: key);

//   @override
//   State<StepDetails> createState() {
//     // ignore: no_logic_in_create_state
//     return _StepDetailsState(pokeStrat, pokeDetails);
//   }
// }

// class _StepDetailsState extends State<StepDetails> {
//   PokeStrat? _pokeStrat;
//   final List<bool> _isOpen = [true, false, false, false];
//   Poke? _pokeDetails;
//   int _level = 50;

//   _StepDetailsState(PokeStrat pokeStrat, Poke pokeDetails) {
//     _pokeStrat = pokeStrat;
//     _pokeDetails = pokeDetails;
//     _level = pokeStrat.level!;
//   }

//   TextStyle styleTitle = const TextStyle(color: Colors.white70, fontSize: 30.0);

//   @override
//   ExpansionPanel build(BuildContext context) {
//     return ExpansionPanel(
//       canTapOnHeader: true,
//       isExpanded: _isOpen[0],
//       body: DisplayDetailsStratWidgets(
//         key: UniqueKey(),
//         gender: _pokeDetails!.gender!,
//         poke: _pokeStrat!,
//         setLevel: (value) => {
//           setState(() {
//             _level = value;
//           })
//         },
//         abilities: _pokeDetails!.abilities,
//       ),
//       headerBuilder: (BuildContext context, bool isExpanded) {
//         return ListTile(
//           title: Text(
//             "Details",
//             style: styleTitle,
//           ),
//         );
//       },
//     );
//   }
// }
