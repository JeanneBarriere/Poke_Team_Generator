import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/model/pokedex_model.dart';
import 'package:front/widget/display_moveset_widget.dart';
import 'package:front/widget/display_stats_widget.dart';
import 'package:front/widget/display_types_widget.dart';
import 'package:front/config/palette.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'list_team_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  String _Username = "";
  String _Password = "";

  Future<Poke> _login() async {
    var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api-token-auth/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': _Username, 'password': _Password}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonResponse["token"]);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TeamListPage(key: UniqueKey(), title: 'Teams')));
    }
    return Future.error("error");
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                      fillColor: Color(0xFF333333f),
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCF1B1B)),
                      ),
                    ),
                    onChanged: (String value) => setState(() {
                      _Username = value;
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                      fillColor: Color(0xFF333333f),
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCF1B1B)),
                      ),
                    ),
                    onChanged: (String value) => setState(() {
                      _Password = value;
                    }),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 38)),
                      onPressed: () {
                        _login();
                      },
                      child: const Text('Login'),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
