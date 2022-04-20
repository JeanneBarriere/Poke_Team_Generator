import 'nature_model.dart';

class Natures {
  final List<Nature>? natures;

  Natures({
    this.natures,
  });

  factory Natures.fromJson(Map<String, dynamic> parsedJson) {
    List<Nature> natures = [];
    parsedJson['results'].forEach((element) => {
          natures.add(Nature(name: element["name"], url: element["url"])),
        });

    return Natures(natures: natures);
  }

  Nature getByName(String name) {
    Nature natureResult = natures!.first;
    for (var nature in natures!) {
      if (nature.name == name) {
        natureResult = nature;
      }
    }
    return natureResult;
  }
}
