// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:front/pages/team_page.dart';
import 'package:front/widget/display_loader.dart';
import 'package:front/widget/team/display_iconsmall_widget.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({Key? key}) : super(key: key);

  @override
  State<GeneratorPage> createState() {
    return _NewGeneratorPage();
  }
}

class _NewGeneratorPage extends State<GeneratorPage> {
  final List<String> _listPoke = [];

  _NewGeneratorPage() {
    _getTeamGenerator();
  }

  Future<List<String>> _getTeamGenerator() async {
    var response = await http.get(
        Uri.parse(
            'http://gentle-ravine-49505.herokuapp.com/getListGenerator/?format=json'),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return (jsonResponse as List).map((item) => item as String).toList();
    } else {
      return Future.error("error");
    }
  }

  TextEditingController myController = TextEditingController()..text = '';

  @override
  StatefulWidget build(BuildContext context) {
    var children = <Widget>[];
    _poke(List<String?>? pokes) {
      if (_listPoke != []) {
        for (var poke in pokes!) {
          children.add(GestureDetector(
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TeamPage(
                  key: UniqueKey(),
                  title: "New Team",
                  teamTitle: "",
                  numGenerator: pokes.indexOf(poke),
                  id: 0,
                ),
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: DisplayIconSmallWidgets(
                  name: poke!.toLowerCase(),
                  size: 60,
                  padding: 8.0,
                ),
              ),
            ),
          ));
        }
      }

      return children;
    }

    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        title: const Text(
          'Generate Team',
        ),
      ),
      body: ListView(children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Choose the first Pokémon of your Team : ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          FutureBuilder<List<String>>(
              future: _getTeamGenerator(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                List<String?>? pokes = snapshot.data;
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
                      return GridView.count(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        children: _poke(pokes),
                        physics: const ScrollPhysics(),
                      );
                    }
                  default:
                    return const Text('');
                }
              })
        ]),
      ]),
    );
  }
}
