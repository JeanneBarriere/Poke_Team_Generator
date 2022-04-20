import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/movepool_model.dart';
import 'package:front/model/poke_strat_model.dart';
import '../display_move_widget.dart';

class DisplayMovesStratWidgets extends StatefulWidget {
  final List<int> baseStat;
  final PokeStrat poke;
  final int level;

  const DisplayMovesStratWidgets({
    Key? key,
    required this.baseStat,
    required this.poke,
    required this.level,
  }) : super(key: key);

  @override
  State<DisplayMovesStratWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayMovesStratWidgetsState(poke);
  }
}

class _DisplayMovesStratWidgetsState extends State<DisplayMovesStratWidgets> {
  PokeStrat? _poke;
  List<String?>? _moves;

  _DisplayMovesStratWidgetsState(PokeStrat poke) {
    _poke = poke;
    _moves = poke.moves!;
  }

  Future<Movepool> _dataMovepool() async {
    final response = await rootBundle.loadString('assets/json/movesLearn.json');
    final jsonResponse = json.decode(response);
    Movepool movepool = Movepool.fromJson(jsonResponse, _poke!.name);
    return movepool;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Palette.kToDark.shade600,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio:
                        (MediaQuery.of(context).size.width * 0.4 / 30),
                    children: List.generate(4, (index) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Palette.kToDark.shade200,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text(
                                    _moves!.length >= index + 1
                                        ? "${_moves![index]![0].toUpperCase()}${_moves![index]!.substring(1)}"
                                        : "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(),
                                  if (_moves!.length >= index + 1)
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      color: const Color(0xFF4A4747),
                                      onPressed: () {
                                        setState(() {
                                          _moves!.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.cancel,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            FutureBuilder<Movepool>(
                future: _dataMovepool(),
                builder:
                    (BuildContext context, AsyncSnapshot<Movepool> snapshot) {
                  Movepool? pokedex = snapshot.data;
                  Widget child;
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      child = const CircularProgressIndicator(
                        key: ValueKey(0), // assign key
                      );
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        );
                      } else {
                        child = Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: pokedex!.moves!
                                          .map((item) => Row(
                                                children: [
                                                  DisplayMoveWidgets(
                                                    key: UniqueKey(),
                                                    label: item,
                                                    width: 0.80,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            primary: _moves!.length <
                                                                        4 &&
                                                                    !_moves!
                                                                        .contains(
                                                                            item)
                                                                ? Palette
                                                                    .kToDark
                                                                : const Color(
                                                                    0xFF727171),
                                                            minimumSize:
                                                                const Size(
                                                                    30, 70)),
                                                    onPressed: () {
                                                      if (_moves!.length < 4 &&
                                                          !_moves!
                                                              .contains(item)) {
                                                        setState(() {
                                                          _moves!.add(item);
                                                        });
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.add,
                                                      size: 15.0,
                                                    ),
                                                  )
                                                ],
                                              ))
                                          .toList()),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      break;
                    default:
                      return const Text('');
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: child,
                  );
                }),
          ],
        ));
  }
}
