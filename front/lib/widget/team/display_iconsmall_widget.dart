import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:http/http.dart' as http;

import '../display_loader.dart';

class DisplayIconSmallWidgets extends StatelessWidget {
  final String? name;
  final double size;
  final double padding;

  Future<Poke> _dataPoke() async {
    var response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/' + name!));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Poke poke = Poke.fromJson(jsonResponse);
      return poke;
    } else if (response.statusCode == 404) {
      Poke poke = Poke.fromnull();
      return poke;
    }
    return Future.error("error");
  }

  const DisplayIconSmallWidgets(
      {Key? key, required this.name, required this.size, required this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder<Poke>(
            future: _dataPoke(),
            builder: (BuildContext context, AsyncSnapshot<Poke> snapshot) {
              Poke? poke = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: DisplayLoader(size: 50));
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                color: Color(0xFF343442),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Image.network("${poke!.icon}",
                                  height: size, width: size),
                            )),
                      ],
                    );
                  }
                default:
                  return const Text('');
              }
            }));
  }
}
