import 'package:flutter/material.dart';
import 'package:front/model/team_list_model.dart';
import 'package:front/pages/team_page.dart';
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
        Uri.parse('http://10.0.2.2:8000/getTeams/?format=json'),
        headers: {"Authorization": "token " + prefs.getString('token')! ?? ""});

    final jsonResponse = jsonDecode(response.body);
    TeamList teamList = TeamList.fromJson(jsonResponse);
    return teamList;
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
          Expanded(
            child: ListView(
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      FutureBuilder<TeamList>(
                          future: _dataTeamList(),
                          builder: (BuildContext context,
                              AsyncSnapshot<TeamList> snapshot) {
                            TeamList? teamList = snapshot.data;
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
                                              children: teamList!.title
                                                  .map((item) => Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        0,
                                                                    vertical:
                                                                        8.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          TeamPage(
                                                                    key:
                                                                        UniqueKey(),
                                                                    title:
                                                                        "Edit Team",
                                                                    teamTitle:
                                                                        item!,
                                                                  ),
                                                                ));
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                            .red[
                                                                        700]!,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  color: const Color(
                                                                      0xFF343442),
                                                                ),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0,
                                                                    vertical:
                                                                        5.0),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.95,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        "${item}",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline3,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  .toList()),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => TeamPage(
                                            key: UniqueKey(),
                                            title: "New Team",
                                            teamTitle: "",
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
