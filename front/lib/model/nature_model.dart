class Nature {
  String name;
  String url;
  String? decreasedStat;
  String? increasedStat;

  Nature(
      {required this.name,
      required this.url,
      this.decreasedStat,
      this.increasedStat});

  factory Nature.fromData(String name, String url) {
    return Nature(name: name, url: url);
  }

  void addDetails(Map<String, dynamic> jsonResponseApi) {
    if (jsonResponseApi['decreased_stat'] != null) {
      decreasedStat = jsonResponseApi['decreased_stat']['name'];
      increasedStat = jsonResponseApi['increased_stat']['name'];
    } else {
      decreasedStat = "";
      increasedStat = "";
    }
  }
}
