import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/team_list_model.dart';
import 'package:front/pages/team_page.dart';
import 'package:front/widget/team/display_iconsmall_widget.dart';
import 'package:front/widget/display_loader.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TeamListPage extends StatefulWidget {
  const TeamListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TeamListPage> createState() => _TeamListPage();
}

class _TeamListPage extends State<TeamListPage> {
  Future<TeamList> _dataTeamList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(
            'http://gentle-ravine-49505.herokuapp.com/getTeams/?format=json'),
        headers: {"Authorization": "token " + prefs.getString('token')!});

    final jsonResponse = jsonDecode(response.body);
    TeamList teamList = TeamList.fromJson(jsonResponse);
    return teamList;
  }

  @override
  StatefulWidget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Center(
                  child: FutureBuilder<TeamList>(
                      future: _dataTeamList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<TeamList> snapshot) {
                        TeamList? teamList = snapshot.data;
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ...teamList!.teams
                                        .map((item) => SizedBox(
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 9.0,
                                                        vertical: 8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeamPage(
                                                            key: UniqueKey(),
                                                            title: "Edit Team",
                                                            teamTitle:
                                                                item.title!,
                                                            numGenerator: -1,
                                                            id: item.id,
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Palette
                                                              .kToDark.shade400,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 5.0,
                                                                vertical: 5.0),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "${item.title}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white70,
                                                                        fontSize:
                                                                            25),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.88,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment: item.pokemon.length >
                                                                                5
                                                                            ? MainAxisAlignment.spaceBetween
                                                                            : MainAxisAlignment.start,
                                                                        children: item
                                                                            .pokemon
                                                                            .map((e) =>
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(2.0),
                                                                                  child: DisplayIconSmallWidgets(
                                                                                    name: e,
                                                                                    size: 45,
                                                                                    padding: 3,
                                                                                  ),
                                                                                ))
                                                                            .toList(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => TeamPage(
                                            key: UniqueKey(),
                                            title: "New Team",
                                            teamTitle: "",
                                            numGenerator: -1,
                                            id: 0,
                                          ),
                                        ));
                                      },
                                      child: const Text('New Team'),
                                    )
                                  ]);
                            }
                          default:
                            return const Text('');
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
