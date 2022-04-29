import 'package:front/model/poke_strat_model.dart';

class Team {
  final String? title;
  final List<PokeStrat> pokemon;
  String newTitle;

  Team({
    this.title,
    required this.newTitle,
    required this.pokemon,
  });

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    List<PokeStrat> pokemon = [];
    for (var poke in parsedJson["team"]) {
      pokemon.add(PokeStrat.fromJson(poke));
    }
    String? title = parsedJson["title"];
    return Team(title: title, newTitle: "", pokemon: pokemon);
  }

  factory Team.create(List<PokeStrat> team, title, newTitle) {
    return Team(title: title, newTitle: newTitle, pokemon: team);
  }

  void update(List<PokeStrat> team, title, newTitle) {
    team = team;
    title = title;
    newTitle = newTitle;
  }
}
