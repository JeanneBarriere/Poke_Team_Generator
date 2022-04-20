import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/model/movepool_model.dart';
import 'package:front/widget/display_move_widget.dart';

import 'display_loader.dart';

class DisplayMovesetWidgets extends StatefulWidget {
  final String? name;

  const DisplayMovesetWidgets({Key? key, required this.name}) : super(key: key);

  @override
  State<DisplayMovesetWidgets> createState() => _DisplayMovesetWidgetsState();
}

class _DisplayMovesetWidgetsState extends State<DisplayMovesetWidgets> {
  Future<Movepool> _dataMovepool() async {
    final response = await rootBundle.loadString('assets/json/movesLearn.json');
    final jsonResponse = json.decode(response);
    Movepool movepool = Movepool.fromJson(jsonResponse, widget.name);
    return movepool;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<Movepool>(
            future: _dataMovepool(),
            builder: (BuildContext context, AsyncSnapshot<Movepool> snapshot) {
              Movepool? pokedex = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: DisplayLoader(size: 40));
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return Column(
                      children: [
                        Text(
                          "Moves",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: pokedex!.moves!
                                      .map((item) => Row(
                                            children: [
                                              DisplayMoveWidgets(
                                                key: UniqueKey(),
                                                label: item,
                                                width: 0.90,
                                              ),
                                            ],
                                          ))
                                      .toList()),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                default:
                  return const Text('');
              }
            }));
  }
}
