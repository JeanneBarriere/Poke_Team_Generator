import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/widget/display_moveset_widget.dart';
import 'package:front/widget/display_stats_widget.dart';
import 'package:front/widget/display_types_widget.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PokemonPage extends StatefulWidget {
  const PokemonPage({Key? key, required this.title, required this.name})
      : super(key: key);

  final String? title;
  final String? name;

  @override
  State<PokemonPage> createState() => _PokemonPage(name!);
}

class _PokemonPage extends State<PokemonPage> {
  @override
  String? _PokeName;

  _PokemonPage(String name) {
    this._PokeName = name.toLowerCase();
  }

  Future<Poke> _dataPoke() async {
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/' + _PokeName!));
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

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                FutureBuilder<Poke>(
                    future: _dataPoke(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Poke> snapshot) {
                      Poke? poke = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(
                              '${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                Text(
                                  "${poke!.name}",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network("${poke.sprite}",
                                        height: 200, width: 200),
                                    DisplayTypesWidgets(
                                      key: UniqueKey(),
                                      strings: poke.types,
                                      size: 50,
                                    ),
                                  ],
                                ),
                                DisplayStatsWidgets(
                                    key: UniqueKey(), strings: poke.stats),
                                DisplayMovesetWidgets(
                                    key: UniqueKey(), name: poke.name)
                              ],
                            );
                          }
                        default:
                          return const Text('');
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
