import 'package:front/model/poke_strat_model.dart';

class TeamSimple {
  final String? title;
  final List<String> pokemon;

  TeamSimple({
    this.title,
    required this.pokemon,
  });

  factory TeamSimple.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson);
    return TeamSimple(
        title: parsedJson["title"], pokemon: parsedJson['list'].cast<String>());
  }
}
