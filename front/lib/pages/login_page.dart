import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/widget/display_loader.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _username = "";
  String _password = "";
  bool loading = false;

  Future<Poke> _login() async {
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse(
            'http://gentle-ravine-49505.herokuapp.com/api-token-auth/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': _username, 'password': _password}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonResponse["token"]);
      loading = false;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TeamListPage(key: UniqueKey(), title: 'Teams')));
    }
    if (response.statusCode == 400) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color(0xFF343442),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          title: const Text('Description',
              style: TextStyle(
                  color: Color(0xFF993030), fontWeight: FontWeight.bold)),
          content: Text(
            "Username or password is incorrect",
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK',
                  style: TextStyle(
                      color: Color(0xFF993030), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      setState(() {
        loading = false;
      });
    }

    setState(() {
      loading = false;
    });
    return Future.error("error");
  }

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
              children: loading
                  ? const [Text('Loading ...'), DisplayLoader(size: 80)]
                  : [
                      Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset("assets/images/artworks/surf.png",
                              height: 400, width: 400)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(color: Colors.white70),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            // ignore: use_full_hex_values_for_flutter_colors
                            labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                            // ignore: use_full_hex_values_for_flutter_colors
                            fillColor: Color(0xFF333333f),
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCF1B1B)),
                            ),
                          ),
                          onChanged: (String value) => setState(() {
                            _username = value;
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(color: Colors.white70),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            // ignore: use_full_hex_values_for_flutter_colors
                            labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                            // ignore: use_full_hex_values_for_flutter_colors
                            fillColor: Color(0xff333333f),
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFCF1B1B)),
                            ),
                          ),
                          onChanged: (String value) => setState(() {
                            _password = value;
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
