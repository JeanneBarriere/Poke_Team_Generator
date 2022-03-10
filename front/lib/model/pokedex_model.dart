class Pokedex {
  final List<String>? names;

  Pokedex({
    this.names,
  });

  factory Pokedex.fromJson(Map<String, dynamic> parsedJson) {
    List<String> pokedex = [];
    parsedJson["results"].forEach((poke) =>
        poke["name"].contains("totem") ? null : pokedex.add(poke["name"]));
    pokedex.remove("greninja-battle-bond");
    pokedex.remove("mimikyu-busted");
    pokedex.remove("magearna-original");
    pokedex.remove("floette-eternal");

    return Pokedex(names: pokedex);
  }
}
