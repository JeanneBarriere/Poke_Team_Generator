class TeamSimple {
  final String? title;
  final List<String> pokemon;
  final int id;

  TeamSimple({this.title, required this.pokemon, required this.id});

  factory TeamSimple.fromJson(Map<String, dynamic> parsedJson) {
    return TeamSimple(
        title: parsedJson["title"],
        pokemon: parsedJson['list'].cast<String>(),
        id: parsedJson['id']);
  }
}
