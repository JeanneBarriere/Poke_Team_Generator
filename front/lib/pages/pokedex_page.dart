import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/pokedex_model.dart';
import 'package:front/pages/pokemon_page.dart';
import 'package:front/widget/display_types_widget.dart';
import 'package:front/widget/generation_dropdown_button.dart';
import 'package:front/widget/type_dropdown_button.dart';
import '../widget/navigation_drawer_widget.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PokedexPage extends StatefulWidget {
  const PokedexPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PokedexPage> createState() => _PokedexPage();
}

class _PokedexPage extends State<PokedexPage> {
  @override
  String _PokeName = "pikachu";
  List<String> _Pokedex = [];
  List<String> _PokedexFilter = [];
  String _generation = "Generation 1";
  String _type1 = "Type";
  String _type2 = "Type";

  Future<Pokedex> _dataPokedex() async {
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=2000'));

    final jsonResponse = jsonDecode(response.body);
    Pokedex pokedex = Pokedex.fromJson(jsonResponse);
    return pokedex;
  }

  Future<Poke> _dataPoke(pokename) async {
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/' + pokename));
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

  _generationFilter() {
    switch (_generation) {
      case "Generation 1":
        _PokedexFilter = _Pokedex.sublist(0, 151);
        break;
      case "Generation 2":
        _PokedexFilter = _Pokedex.sublist(151, 251);
        break;
      case "Generation 3":
        _PokedexFilter = _Pokedex.sublist(251, 386);
        break;
      case "Generation 4":
        _PokedexFilter = _Pokedex.sublist(386, 493);
        break;
      case "Generation 5":
        _PokedexFilter = _Pokedex.sublist(493, 649);
        break;
      case "Generation 6":
        _PokedexFilter = _Pokedex.sublist(649, 721);
        break;
      case "Generation 7":
        _PokedexFilter = _Pokedex.sublist(721, 809);
        break;
      case "Generation 8":
        _PokedexFilter = _Pokedex.sublist(809, 898);
        break;
      default:
    }
  }

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(children: [
            GenerationDropDownButton(
                key: UniqueKey(),
                index: _generation,
                onPress: (String? newValue) {
                  setState(() {
                    _generation = newValue!;
                  });
                  _generationFilter();
                }),
            TypeDropDownButton(
                key: UniqueKey(),
                index: _type1,
                onPress: (String? newValue) {
                  setState(() {
                    _type1 = newValue!;
                  });
                  _generationFilter();
                }),
            TypeDropDownButton(
                key: UniqueKey(),
                index: _type2,
                onPress: (String? newValue) {
                  setState(() {
                    _type2 = newValue!;
                  });
                  _generationFilter();
                }),
          ]),
          Expanded(
            child: ListView(
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
                                return const Center(
                                    child: CircularProgressIndicator());
                              case ConnectionState.done:
                                if (snapshot.hasError) {
                                  return Text(
                                    '${snapshot.error}',
                                    style: const TextStyle(color: Colors.red),
                                  );
                                } else {
                                  _Pokedex = pokedex!.names!;
                                  _generationFilter();
                                  return Column(children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 3.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children:
                                                  _PokedexFilter.map(
                                                      (item) => Row(
                                                            children: [
                                                              FutureBuilder<
                                                                      Poke>(
                                                                  future:
                                                                      _dataPoke(
                                                                          item),
                                                                  builder: (BuildContext
                                                                          context,
                                                                      AsyncSnapshot<
                                                                              Poke>
                                                                          snapshot) {
                                                                    Poke? poke =
                                                                        snapshot
                                                                            .data;
                                                                    switch (snapshot
                                                                        .connectionState) {
                                                                      case ConnectionState
                                                                          .waiting:
                                                                        return Center(
                                                                            child:
                                                                                Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 0,
                                                                              vertical: 8.0),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.red[700]!,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                              color: const Color(0xFF343442),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.95,
                                                                            height:
                                                                                110.0,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: const [
                                                                                CircularProgressIndicator(),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                            // child:
                                                                            //     CircularProgressIndicator()
                                                                            );
                                                                      case ConnectionState
                                                                          .done:
                                                                        if (snapshot
                                                                            .hasError) {
                                                                          return Text(
                                                                            '${snapshot.error}',
                                                                            style:
                                                                                const TextStyle(color: Colors.red),
                                                                          );
                                                                        } else {
                                                                          return Visibility(
                                                                            visible:
                                                                                (_type1 == "Type" || poke!.types.contains(_type1)) && (_type2 == "Type" || poke!.types.contains(_type2)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                                    builder: (context) => PokemonPage(key: UniqueKey(), title: poke!.name, name: poke.name),
                                                                                  ));
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: Colors.red[700]!,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                    color: const Color(0xFF343442),
                                                                                  ),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                                                                  width: MediaQuery.of(context).size.width * 0.95,
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Image.network("${poke!.icon}", height: 100, width: 100),
                                                                                          DisplayTypesWidgets(key: UniqueKey(), strings: poke.types, size: 30),
                                                                                        ],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          "${poke.name}",
                                                                                          style: Theme.of(context).textTheme.headline3,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                      default:
                                                                        return const Text(
                                                                            '');
                                                                    }
                                                                  }),
                                                            ],
                                                          )).toList()),
                                        ),
                                      ],
                                    )
                                  ]);
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
          ),
        ],
      ),
    );
  }
}