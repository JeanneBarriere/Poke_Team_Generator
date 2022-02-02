import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/pokedex_model.dart';
import 'package:front/model/team_model.dart';
import 'package:front/pages/list_team_page.dart';
import 'package:front/widget/display_icon_small_banner_widget.dart';
import 'package:front/widget/display_stats_widget.dart';
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
    return _NewTeamPage(teamTitle == null ? "" : teamTitle);
  }
}

class _NewTeamPage extends State<TeamPage> {
  String _PokeName = "pikachu";
  List<String> _Pokedex = [];
  List<String> _Team = [];
  String _Title = "";
  String _NewTitle = "";
  bool _update = false;
  int? _current = null;

  _NewTeamPage(String teamTitle) {
    if (teamTitle != "" && teamTitle != null) {
      _Title = teamTitle;
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
    var response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/' + _PokeName));
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

  Future<Poke> _addTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response =
        await http.post(Uri.parse('http://10.0.2.2:8000/addTeam/?format=json'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "token " + prefs.getString('token')! ?? ""
            },
            body: json.encode({'title': _NewTitle, 'team': _Team}));
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
        body: json
            .encode({'title': _Title, 'newTitle': _NewTitle, 'team': _Team}));
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
        body: json.encode({'title': _Title}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Team team = Team.fromJson(jsonResponse);
      setState(() {
        _Team = team.pokemon;
        _update = true;
        _NewTitle = _Title;
      });
      myController.text = _NewTitle;
    } else {
      return Future.error("error");
    }
  }

  _displayPoke(value) {
    if (value == "") {
      Random random = Random();
      int randomNumber = random.nextInt(901);
      setState(() {
        _PokeName = randomNumber.toString();
      });
    } else {
      setState(() {
        _PokeName = value.toLowerCase();
      });
    }
  }

  TextEditingController myController = TextEditingController()..text = '';

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: myController,
                          onChanged: (value) => setState(() {
                            _NewTitle = value;
                          }),
                          autofocus: false,
                          style: const TextStyle(color: Color(0xFFFAFAFAf)),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title of Team',
                            labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                            fillColor: Color(0xFF333333f),
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
                          onPressed: () {
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
                  listPoke: _Team,
                  onPress: (int? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _current = newValue!;
                        _PokeName = _Team[newValue];
                      } else {
                        _PokeName = 'pikachu';
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
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
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
                                                  // enabledBorder:
                                                  //     UnderlineInputBorder(
                                                  //   borderSide: BorderSide(
                                                  //       color:
                                                  //           Color(0xFFCF1B1B)),
                                                  // ),
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
                                                          primary: _Team
                                                                      .length <
                                                                  6
                                                              ? Palette.kToDark
                                                              : const Color(
                                                                  0xFF727171),
                                                          minimumSize:
                                                              const Size(
                                                                  100, 38)),
                                                  onPressed: () {
                                                    if (_Team.length < 6) {
                                                      setState(() {
                                                        _Team.add(_PokeName);
                                                      });
                                                    }
                                                  },
                                                  child:
                                                      const Text('Add Pokemon'),
                                                )
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: _Team
                                                                      .length <
                                                                  6
                                                              ? Palette.kToDark
                                                              : const Color(
                                                                  0xFF727171),
                                                          minimumSize:
                                                              const Size(
                                                                  100, 38)),
                                                  onPressed: () {
                                                    if (_Team.length < 6) {
                                                      setState(() {
                                                        _Team[_current!] =
                                                            _PokeName;
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
                                              primary: _Team.length < 6
                                                  ? Palette.kToDark
                                                  : const Color(0xFF727171),
                                              minimumSize: const Size(50, 38)),
                                          onPressed: () {
                                            setState(() {
                                              _Team.removeAt(_current!);
                                              _current = null;
                                              _PokeName = 'bulbasaur';
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
                                        size: 50),
                                  ],
                                ),
                                DisplayStatsWidgets(
                                    key: UniqueKey(), strings: poke.stats),
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
