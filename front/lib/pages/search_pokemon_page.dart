// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/pokedex_model.dart';
import 'package:front/widget/display_loader.dart';
import 'package:front/widget/display_moveset_widget.dart';
import 'package:front/widget/display_stats_widget.dart';
import 'package:front/widget/display_types_widget.dart';
import '../widget/navigation_drawer_widget.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SearchPokemonPage extends StatefulWidget {
  const SearchPokemonPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchPokemonPage> createState() => _SearchPokemonPage();
}

class _SearchPokemonPage extends State<SearchPokemonPage> {
  String _pokeName = "pikachu";
  final List<String> _pokedex = [];

  Future<Pokedex> _dataPokedex() async {
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=2000'));

    final jsonResponse = jsonDecode(response.body);
    Pokedex pokedex = Pokedex.fromJson(jsonResponse);
    return pokedex;
  }

  Future<Poke> _dataPoke() async {
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/' + _pokeName));
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

  _displayPoke(value) {
    if (value == "") {
      Random random = Random();
      int randomNumber = random.nextInt(901);
      setState(() {
        _pokeName = randomNumber.toString();
      });
    } else {
      setState(() {
        _pokeName = value.toLowerCase();
      });
    }
  }

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                FutureBuilder<Pokedex>(
                    future: _dataPokedex(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Pokedex> snapshot) {
                      Pokedex? pokedex = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: DisplayLoader());
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(
                              '${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Autocomplete(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return pokedex!.names!
                                            .where((String option) {
                                          return option.contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (value) =>
                                          _displayPoke(value),
                                      fieldViewBuilder: (context, controller,
                                          focusNode, onFieldSubmitted) {
                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          onEditingComplete: onFieldSubmitted,
                                          onSubmitted: (value) =>
                                              _displayPoke(value),
                                          autofocus: false,
                                          style: const TextStyle(
                                              color: Color(0xFFFAFAFAf)),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Pokemon name',
                                            labelStyle: TextStyle(
                                                color: Color(0xFFFAFAFAf)),
                                            fillColor: Color(0xFF333333f),
                                            filled: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFCF1B1B)),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            );
                          }
                        default:
                          return const Text('');
                      }
                    }),
                FutureBuilder<Poke>(
                    future: _dataPoke(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Poke> snapshot) {
                      Poke? poke = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: DisplayLoader());
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
                                        size: 50),
                                  ],
                                ),
                                DisplayStatsWidgets(
                                    key: UniqueKey(), stats: poke.stats),
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
