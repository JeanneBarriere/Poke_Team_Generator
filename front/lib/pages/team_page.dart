// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/natures_model.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/poke_strat_model.dart';
import 'package:front/model/pokedex_model.dart';
import 'package:front/model/team_model.dart';
import 'package:front/pages/list_team_page.dart';
import 'package:front/widget/display_loader.dart';
import 'package:front/widget/team/display_icon_small_banner_widget.dart';
import 'package:front/widget/team/display_strat_step_widget.dart';
import 'package:front/widget/display_types_widget.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key, required this.title, required this.teamTitle})
      : super(key: key);

  final String title;
  final String teamTitle;

  @override
  State<TeamPage> createState() {
    // ignore: no_logic_in_create_state, prefer_if_null_operators, unnecessary_null_comparison
    return _NewTeamPage(teamTitle == null ? "" : teamTitle);
  }
}

class _NewTeamPage extends State<TeamPage> {
  String _pokeName = "pikachu";
  List<PokeStrat> _team = [];
  String _title = "";
  String _newTitle = "";
  bool _update = false;
  int? _current;
  PokeStrat _pokeStrat = PokeStrat.fromName("pikachu");

  _NewTeamPage(String teamTitle) {
    // ignore: unnecessary_null_comparison
    if (teamTitle != null && teamTitle != "") {
      _title = teamTitle;
      _getTeamTitle();
    }
  }

  Future<Pokedex> _dataPokedex() async {
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=2000'));

    final jsonResponse = jsonDecode(response.body);
    Pokedex pokedex = Pokedex.fromJson(jsonResponse);
    return pokedex;
  }

  Future<Poke> _dataPokeDetail() async {
    var response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/' + _pokeStrat.name!));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Poke poke = Poke.fromJson(jsonResponse);
      var responseSpecies = await http.get(Uri.parse(poke.urlSpecies!));
      if (responseSpecies.statusCode == 200) {
        final jsonResponseSpecies = jsonDecode(responseSpecies.body);
        poke.addSpecies(jsonResponseSpecies);
        return poke;
      }
      return poke;
    } else if (response.statusCode == 404) {
      Poke poke = Poke.fromnull();
      return poke;
    }
    return Future.error("error");
  }

  List teamToJson() {
    return _team.map((poke) => (poke.toJson())).toList();
  }

  Future<Poke> _addTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response =
        await http.post(Uri.parse('http://10.0.2.2:8000/addTeam/?format=json'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "token " + prefs.getString('token')!
            },
            body: json.encode({
              'title': _newTitle,
              'team': teamToJson(),
            }));
    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TeamListPage(key: UniqueKey(), title: 'Teams')));
    }
    return Future.error("error");
  }

  Future<Poke> _editTeam() async {
    var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/editTeam/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {'title': _title, 'newTitle': _newTitle, 'team': teamToJson()}));
    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TeamListPage(key: UniqueKey(), title: 'Teams')));
    }
    return Future.error("error");
  }

  Future<void> _getTeamTitle() async {
    var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/getTeamTitle/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'title': _title}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Team team = Team.fromJson(jsonResponse);
      setState(() {
        // _team = team.pokemon;
        _update = true;
        _newTitle = _title;
        _team = team.pokemon;
        if (team.pokemon.isNotEmpty) {
          _pokeStrat = team.pokemon[0];
          _current = 0;
        }
      });
      myController.text = _newTitle;
    } else {
      return Future.error("error");
    }
  }

  Future<Natures> _dataNature() async {
    var response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/nature/'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Natures natures = Natures.fromJson(jsonResponse);
      for (var nature in natures.natures!) {
        var responseNature = await http.get(Uri.parse(nature.url));
        final jsonNatures = jsonDecode(responseNature.body);
        nature.addDetails(jsonNatures);
      }
      return natures;
    }
    return Future.error("error");
  }

  _displayPoke(value) {
    if (value == "") {
      Random random = Random();
      int randomNumber = random.nextInt(901);
      setState(() {
        _pokeName = randomNumber.toString();
        _pokeStrat = PokeStrat.fromName(randomNumber.toString());
      });
    } else {
      setState(() {
        _pokeName = value.toLowerCase();
        _pokeStrat = PokeStrat.fromName(value.toLowerCase());
      });
    }
  }

  TextEditingController myController = TextEditingController()..text = '';

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: myController,
                          onChanged: (value) => setState(() {
                            _newTitle = value;
                          }),
                          autofocus: false,
                          style: const TextStyle(color: Color(0xfffafafaf)),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title of Team',
                            labelStyle: TextStyle(color: Color(0xfffafafaf)),
                            fillColor: Color(0xff333333f),
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCF1B1B)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(125, 60)),
                          onPressed: _team.length == 0
                              ? null
                              : () {
                                  if (_update) {
                                    _editTeam();
                                  } else {
                                    _addTeam();
                                  }
                                },
                          child: const Text('Save Team'),
                        ),
                      ),
                    ],
                  ),
                ),
                DisplayIconSmallBannerWidgets(
                  listPoke: _team,
                  onPress: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _current = newValue;
                        _pokeStrat = _team[newValue];
                      } else {
                        _pokeStrat = PokeStrat.fromName('pikachu');
                        _pokeName = 'pikachu';
                        _current = null;
                      }
                    });
                  },
                  current: _current,
                ),
                FutureBuilder<Pokedex>(
                    future: _dataPokedex(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Pokedex> snapshot) {
                      Pokedex? pokedex = snapshot.data;
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
                            return Column(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 220,
                                          child: Autocomplete(
                                            optionsBuilder: (TextEditingValue
                                                textEditingValue) {
                                              if (textEditingValue.text == '') {
                                                return const Iterable<
                                                    String>.empty();
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
                                            fieldViewBuilder: (context,
                                                controller,
                                                focusNode,
                                                onFieldSubmitted) {
                                              return TextField(
                                                controller: controller,
                                                focusNode: focusNode,
                                                onEditingComplete:
                                                    onFieldSubmitted,
                                                onSubmitted: (value) =>
                                                    _displayPoke(value),
                                                autofocus: false,
                                                style: const TextStyle(
                                                    color: Color(0xFFFAFAFAf)),
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Pokemon name',
                                                  labelStyle: TextStyle(
                                                      color:
                                                          Color(0xFFFAFAFAf)),
                                                  fillColor: Color(0xFF333333f),
                                                  filled: true,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: _current == null
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: _team
                                                                      .length <
                                                                  6
                                                              ? Palette.kToDark
                                                              : const Color(
                                                                  0xFF727171),
                                                          minimumSize:
                                                              const Size(
                                                                  100, 38)),
                                                  onPressed: () {
                                                    if (_team.length < 6) {
                                                      setState(() {
                                                        _team.add(_pokeStrat);
                                                        _current =
                                                            _team.length - 1;
                                                      });
                                                    }
                                                  },
                                                  child:
                                                      const Text('Add Pokemon'),
                                                )
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: _team
                                                                      .length <
                                                                  6
                                                              ? Palette.kToDark
                                                              : const Color(
                                                                  0xFF727171),
                                                          minimumSize:
                                                              const Size(
                                                                  100, 38)),
                                                  onPressed: () {
                                                    if (_team.length < 6) {
                                                      setState(() {
                                                        _team[_current!] =
                                                            PokeStrat.fromName(
                                                                _pokeName);
                                                      });
                                                    }
                                                  },
                                                  child: const Text('Change'),
                                                ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: _current != null
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: _team.length < 6
                                                  ? Palette.kToDark
                                                  : const Color(0xFF727171),
                                              minimumSize: const Size(50, 38)),
                                          onPressed: () {
                                            setState(() {
                                              _team.removeAt(_current!);
                                              _current = null;
                                              _pokeStrat = PokeStrat.fromName(
                                                  'bulbasaur');
                                              _pokeName = 'bulbasaur';
                                            });
                                          },
                                          child: const Text('Delete'),
                                        )
                                      : Container(),
                                ),
                              ],
                            );
                          }
                        default:
                          return const Text('');
                      }
                    }),
                FutureBuilder<Poke>(
                    future: _dataPokeDetail(),
                    builder:
                        (BuildContext context, AsyncSnapshot<Poke> snapshot) {
                      Poke? poke = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(child: DisplayLoader(size: 80));
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(
                              '${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            );
                          } else {
                            return FutureBuilder<Natures>(
                                future: _dataNature(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Natures> snapshot) {
                                  Natures? natures = snapshot.data;
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const Center(
                                          child: DisplayLoader(size: 80));
                                    case ConnectionState.done:
                                      if (snapshot.hasError) {
                                        return Text(
                                          '${snapshot.error}',
                                          style: const TextStyle(
                                              color: Colors.red),
                                        );
                                      } else {
                                        return Column(
                                          children: <Widget>[
                                            Text(
                                              "${poke!.name}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.network("${poke.sprite}",
                                                    height: 200, width: 200),
                                                DisplayTypesWidgets(
                                                    key: UniqueKey(),
                                                    strings: poke.types,
                                                    size: 50),
                                              ],
                                            ),
                                            DisplayStratStepWidgets(
                                                key: UniqueKey(),
                                                pokeStrat: _pokeStrat,
                                                pokeDetails: poke,
                                                natures: natures!)
                                          ],
                                        );
                                      }
                                    default:
                                      return const Text('');
                                  }
                                });
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
