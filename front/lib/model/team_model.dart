import 'package:front/model/poke_strat_model.dart';

class Team {
  final String? title;
  final List<PokeStrat> pokemon;

  Team({
    this.title,
    required this.pokemon,
  });

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    List<PokeStrat> pokemon = [];
    for (var poke in parsedJson["team"]) {
      pokemon.add(PokeStrat.fromJson(poke));
    }
    String? title = parsedJson["title"];
    return Team(title: title, pokemon: pokemon);
  }
}
