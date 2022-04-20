class Item {
  late String name;
  String description;
  String? url;
  String? sprites;

  Item({required this.name, required this.description, this.url, this.sprites});

  factory Item.fromData(String name, String description) {
    return Item(name: name, description: description);
  }

  factory Item.fromJson(Map<String, dynamic> parsedJson, String name) {
    String description = "";
    parsedJson.forEach(
        (k, v) => {if (!v.containsValue(name)) description = v["desc"]});

    return Item(name: name, description: description);
  }

  void addUrl(String url) {
    this.url = url;
  }

  void addUrlFromJSon(Map<String, dynamic> jsonResponseApi) {
    String url = "https://pokeapi.co/api/v2/item/4/";
    jsonResponseApi["results"].forEach((element) => {
          if (element["name"] == name.toLowerCase()) {url = element['url']}
        });
    this.url = url;
  }

  void addSprites(jsonResponseApiUrl) {
    if (jsonResponseApiUrl["sprites"]["default"] != null) {
      sprites = jsonResponseApiUrl["sprites"]["default"];
    } else {
      sprites =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png";
    }
  }
}
