class TeamList {
  final List<String?> title;

  TeamList({
    required this.title,
  });

  factory TeamList.fromJson(Map<String, dynamic> parsedJson) {
    List<String?> title = List<String>.from(parsedJson["list"]);
    return TeamList(title: title);
  }
}
