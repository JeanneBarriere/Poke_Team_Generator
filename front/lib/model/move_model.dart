import 'package:intl/intl.dart';

class Move {
  final String? label;
  final List<String?>? type;
  final String? accuracy;
  final String? basePower;
  final String? name;
  final String? category;
  final String? pp;
  final String? description;

  Move(
      {this.label,
      this.type,
      this.accuracy,
      this.basePower,
      this.name,
      this.category,
      this.pp,
      this.description});

  factory Move.fromJson(Map<String, dynamic> parsedJson, String? label) {
    List<String?> type = [];
    type.add(toBeginningOfSentenceCase(parsedJson[label]['type'] as String?));
    var accuracy = parsedJson[label]['accuracy'] == true
        ? 'never fail'
        : parsedJson[label]['accuracy'].toString();
    var basePower = parsedJson[label]['basePower'] == 0
        ? "_"
        : parsedJson[label]['basePower'].toString();
    var name = parsedJson[label]['name'];
    var category = parsedJson[label]['category'];
    var pp = parsedJson[label]['pp'].toString();
    var description = parsedJson[label]['desc'].toString();

    return Move(
        label: label,
        type: type,
        accuracy: accuracy,
        basePower: basePower,
        name: name,
        category: category,
        pp: pp,
        description: description);
  }
}
