import 'package:front/model/poke_model.dart';
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

  // Map toJson(String title, String newTitle, List<PokeStrat> team) {
  //   List teamJson = []
  //   Map team =
  //       this.author != null ? this.author.toJson() : null;
  //   return {'title': title, 'description': description, 'author': author};
  // }
}
