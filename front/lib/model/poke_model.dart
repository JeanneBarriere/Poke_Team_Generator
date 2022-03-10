import 'dart:convert';

import 'package:intl/intl.Dart';
import 'package:http/http.dart' as http;

class Poke {
  final String? name;
  final String? sprite;
  final String? icon;
  final String? iconSmall;
  final List<String?> types;
  final List<int?> stats;
  int? gender;
  final String? urlSpecies;

  Poke(
      {this.name,
      this.sprite,
      this.icon,
      this.iconSmall,
      required this.types,
      required this.stats,
      this.gender,
      this.urlSpecies});

  factory Poke.fromJson(Map<String, dynamic> parsedJson) {
    List<String?> types = [];
    parsedJson["types"].forEach((type) =>
        types.add(toBeginningOfSentenceCase(type["type"]["name"] as String?)));
    List<int?> stats = [];
    parsedJson["stats"].forEach((stat) => stats.add(stat["base_stat"]));
    return Poke(
      name: toBeginningOfSentenceCase(parsedJson["name"] as String?),
      sprite: parsedJson["sprites"]["other"]["official-artwork"]
          ["front_default"] as String?,
      icon: parsedJson["sprites"]["front_default"] as String?,
      iconSmall: parsedJson["sprites"]["versions"]["generation-viii"]["icons"]
          ["front_default"] as String?,
      types: types,
      stats: stats,
      urlSpecies: parsedJson["species"]["url"],
    );
  }

  void addSpecies(Map<String, dynamic> parsedJson) {
    gender = parsedJson["gender_rate"];
  }

  factory Poke.fromnull() {
    return Poke(
        name: "Ditto",
        sprite:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/132.png",
        types: ["Normal"],
        stats: [48, 48, 48, 48, 48, 48]);
  }
}
