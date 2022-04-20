import 'package:front/model/item_model.dart';

class Items {
  final List<Item>? items;

  Items({
    this.items,
  });

  factory Items.fromJson(Map<String, dynamic> parsedJson) {
    List<Item> items = [];
    parsedJson.forEach((k, v) => {
          if (!v.containsKey("isNonstandard"))
            items.add(Item(name: v["name"], description: v["desc"])),
        });

    return Items(items: items);
  }

  void addSprites(Map<String, dynamic> jsonResponseApi) {
    String itemName;
    String url = "https://pokeapi.co/api/v2/item/4/";
    items!.forEach((Item item) => {
          itemName = item.name.replaceAll(" ", "-"),
          itemName = itemName.toLowerCase(),
          jsonResponseApi["results"].forEach((element) =>
              {if (element["name"] == itemName) url = element['url']}),
          item.addUrl(url)
        });
  }
}
