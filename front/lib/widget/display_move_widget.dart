import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/model/move_model.dart';
import 'display_types_widget.dart';

class DisplayMoveWidgets extends StatefulWidget {
  final String? label;
  final double width;

  const DisplayMoveWidgets({Key? key, required this.label, required this.width})
      : super(key: key);

  @override
  State<DisplayMoveWidgets> createState() => _DisplayMoveWidgetsState();
}

class _DisplayMoveWidgetsState extends State<DisplayMoveWidgets> {
  Future<Move> _dataMove() async {
    final response = await rootBundle.loadString('assets/json/moves.json');
    final jsonResponse = json.decode(response);
    Move move = Move.fromJson(jsonResponse, widget.label);
    return move;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: FutureBuilder<Move>(
            future: _dataMove(),
            builder: (BuildContext context, AsyncSnapshot<Move> snapshot) {
              Move? move = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center();
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    var category = {
                      'Status': const Color(0xFF385349),
                      'Physical': const Color(0xFF5C3434),
                      'Special': const Color(0xFF433C83)
                    };
                    return GestureDetector(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          backgroundColor: const Color(0xFF343442),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          title: const Text('Description',
                              style: TextStyle(
                                  color: Color(0xFF993030),
                                  fontWeight: FontWeight.bold)),
                          content: Text(
                            move!.description!,
                            style: TextStyle(
                              color: Colors.grey[300],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK',
                                  style: TextStyle(
                                      color: Color(0xFF993030),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * widget.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFF343442),
                        ),
                        child: Column(
                          children: [
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: DisplayTypesWidgets(
                                  key: UniqueKey(),
                                  strings: move!.type!,
                                  size: 25,
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  move.name!,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: category[move.category],
                                ),
                                child: SizedBox(
                                  width: 75,
                                  child: Text(
                                    move.category!,
                                    textAlign: TextAlign.center,
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 0.9),
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: [
                              Text(
                                "Power : " + move.basePower!,
                                textAlign: TextAlign.start,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 0.93),
                              ),
                              const Spacer(),
                              Text(
                                "Accuracy : " + move.accuracy!,
                                textAlign: TextAlign.start,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 0.93),
                              ),
                              const Spacer(),
                              Text(
                                "PP : " + move.pp!,
                                textAlign: TextAlign.start,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 0.93),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    );
                  }
                default:
                  return const Text('');
              }
            }));
  }
}
