import 'package:intl/intl.Dart';

class Poke {
  final String? name;
  final String? sprite;
  final String? icon;
  final String? iconSmall;
  final List<String?> types;
  final List<int> stats;
  final List<String> abilities;
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
      required this.abilities,
      this.urlSpecies});

  factory Poke.fromJson(Map<String, dynamic> parsedJson) {
    List<String?> types = [];
    parsedJson["types"].forEach((type) =>
        types.add(toBeginningOfSentenceCase(type["type"]["name"] as String?)));
    List<String> abilities = [];
    parsedJson["abilities"].forEach(
        (ability) => abilities.add((ability["ability"]["name"] as String)));
    List<int> stats = [];
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
      abilities: abilities,
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
        abilities: [],
        stats: [48, 48, 48, 48, 48, 48]);
  }
}
