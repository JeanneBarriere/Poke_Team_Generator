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
    return PokeStrat();
  }

  factory PokeStrat.fromName(String name) {
    return PokeStrat(
        name: name,
        nickName: "",
        shiny: false,
        gender: "random",
        item: "",
        ability: "",
        level: 50,
        evs: [0, 0, 0, 0, 0, 0],
        nature: "",
        ivs: [31, 31, 31, 31, 31, 31],
        moves: ["", "", "", ""]);
  }
}
