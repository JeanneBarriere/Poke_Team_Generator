import 'package:flutter/cupertino.dart';
import 'package:intl/intl.Dart';

class Poke {
  final String? name;
  final String? sprite;
  final String? icon;
  final String? icon_small;
  final List<String?> types;
  final List<int?> stats;
  //final List<String> streets;

  Poke({
    this.name,
    this.sprite,
    this.icon,
    this.icon_small,
    required this.types,
    required this.stats,
    // this.streets
  });

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
        icon_small: parsedJson["sprites"]["versions"]["generation-viii"]
            ["icons"]["front_default"] as String?,
        types: types,
        stats: stats);
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
