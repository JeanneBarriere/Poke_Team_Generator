class Movepool {
  final List<String>? moves;

  Movepool({
    this.moves,
  });

  factory Movepool.fromJson(Map<String, dynamic> parsedJson, String? name) {
    name = name!.toLowerCase();
    var list = [
      "incarnate",
      "altered",
      "origin",
      "mega-x",
      "mega-y",
      "gmax",
      "single-strike",
      "rapid-strike",
      "school",
      "sunny",
      "rainy",
      "snowy",
      "primal",
      "sky",
      "red-striped",
      "blue-striped",
      "standard",
      "therian",
      "ordinary",
      "resolute",
      "50",
      "complete",
      "unbound",
      "midday",
      "disguised",
      "busted",
      "eternamax",
      "rider"
    ];
    for (var element in list) {
      name = name!.replaceAll(element, "");
    }
    name = name!.contains('pikachu') ? 'pikachu' : name;
    name = name.contains('deoxys') ? 'deoxys' : name;
    name = name.contains('meloetta') ? 'meloetta' : name;
    name = name.contains('greninja') ? 'greninja' : name;
    name = name.contains('aegislash') ? 'aegislash' : name;
    name = name.contains('pumpkaboo') ? 'pumpkaboo' : name;
    name = name.contains('oricorio') ? 'oricorio' : name;
    name = name.contains('minior') ? 'minior' : name;
    name = name.contains('toxtricity') ? 'toxtricity' : name;
    name = name.contains('eiscue') ? 'eiscue' : name;
    name = name.contains('zacian') ? 'zacian' : name;
    name = name.contains('zamazenta') ? 'zamazenta' : name;
    name = name.contains('nidoran') ? 'nidoran' : name;

    name = name.contains('necrozma-dusk') ? 'necrozmaduskmane' : name;
    name = name.contains('necrozma-dawn') ? 'necrozmadawnwings' : name;

    name = name.contains('darmanitan') ? name.replaceAll('zen', "") : name;

    name = name.replaceAll("-", "");
    List<String> moves = [];
    parsedJson[name]['learnset'].forEach((k, v) => moves.add(k));

    if (name.contains('rotom') && name.length > 5) {
      parsedJson['rotom']['learnset'].forEach((k, v) => moves.add(k));
    }
    if (name.contains('necrozma') && name.length > 5) {
      parsedJson['necrozma']['learnset'].forEach((k, v) => moves.add(k));
    }

    return Movepool(moves: moves);
  }
}
