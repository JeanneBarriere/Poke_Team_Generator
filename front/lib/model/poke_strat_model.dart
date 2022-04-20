class PokeStrat {
  String? name;
  String? nickName;
  bool? shiny;
  String? gender;
  String? item;
  String? ability;
  int? level;
  List<double>? evs;
  String? nature;
  List<double>? ivs;
  List<String?>? moves;

  PokeStrat(
      {this.name,
      this.nickName,
      this.shiny,
      this.gender,
      this.item,
      this.ability,
      this.level,
      this.evs,
      this.nature,
      this.ivs,
      this.moves});

  factory PokeStrat.fromJson(Map<String, dynamic> parsedJson) {
    // List<String> moves =[];
    // parsedJson['moves']!.for (var item in items) {

    // }
    return PokeStrat(
        name: parsedJson['name'],
        nickName: parsedJson['nickName'],
        shiny: parsedJson['shiny'].toString() == "true",
        gender: parsedJson['gender'],
        item: parsedJson['item'],
        ability: parsedJson['ability'],
        level: parsedJson['level'],
        evs: parsedJson['evs'].cast<double>(),
        nature: (parsedJson['nature']),
        ivs: parsedJson['ivs'].cast<double>(),
        moves: parsedJson['moves'].cast<String>());
  }

  factory PokeStrat.fromName(String name) {
    return PokeStrat(
        name: name,
        nickName: "",
        shiny: false,
        gender: "",
        item: "",
        ability: "",
        level: 50,
        evs: [0, 0, 0, 0, 0, 0],
        nature: "",
        ivs: [31, 31, 31, 31, 31, 31],
        moves: []);
  }

  Map toJson() {
    return {
      "name": name,
      "nickName": nickName,
      "shiny": shiny,
      "gender": gender,
      "item": item,
      "ability": ability,
      "level": level,
      "evs": evs,
      "nature": nature,
      "ivs": ivs,
      "moves": moves
    };
  }
}
