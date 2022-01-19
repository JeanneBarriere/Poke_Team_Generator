import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:http/http.dart' as http;

class DisplayIconSmallWidgets extends StatelessWidget {
  final String? name;

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

  const DisplayIconSmallWidgets({Key? key, required this.name})
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
                  return const Center(child: CircularProgressIndicator());
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
                                color: const Color(0xFF343442),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network("${poke!.icon}",
                                  height: 40, width: 40),
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
