import 'package:flutter/cupertino.dart';
import 'package:intl/intl.Dart';

class Team {
  final String? title;
  final List<String> pokemon;

  Team({
    this.title,
    required this.pokemon,
  });

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    List<String> pokemon = List<String>.from(parsedJson["team"]["team"]);
    String? title = parsedJson['team']["title"];
    return Team(title: title, pokemon: pokemon);
  }
}
