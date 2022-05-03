// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:front/model/poke_model.dart';
import 'package:front/pages/login_page.dart';
import 'package:front/widget/display_loader.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  String _username = "";
  String _password = "";
  bool _loading = false;

  void alert(String message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF343442),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        title: const Text('Description',
            style: TextStyle(
                color: Color(0xFF993030), fontWeight: FontWeight.bold)),
        content: Text(
          message,
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
  }

  Future<Poke> _login() async {
    if (_username == "" || _password == "") {
      alert("Username and password must not be empty");
      return Future.error("Username and password must not be empty");
    }
    _loading = true;
    var response = await http.post(
        Uri.parse(
            'http://gentle-ravine-49505.herokuapp.com/create_user/?format=json'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': _username, 'password': _password}));
    if (response.statusCode == 200) {
      // final jsonResponse = jsonDecode(response.body);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(key: UniqueKey(), title: 'Login')));
    }
    if (response.statusCode == 400) {
      // final jsonResponse = jsonDecode(response.body);
      alert("User alreaydy exist");
      _loading = false;
    }
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
              children: _loading
                  ? const [Text('Loading ...'), DisplayLoader(size: 80)]
                  : [
                      Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                              "assets/images/artworks/charizard.png",
                              height: 400,
                              width: 400)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: const TextStyle(color: Colors.white70),
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
                            _username = value;
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(color: Colors.white70),
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
                            child: const Text('Register'),
                          ))
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
