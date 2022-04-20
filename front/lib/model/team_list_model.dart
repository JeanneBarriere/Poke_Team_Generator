import 'package:front/model/team_simple_model.dart';

class TeamList {
  final List<TeamSimple> teams;

  TeamList({
    required this.teams,
  });

  factory TeamList.fromJson(Map<String, dynamic> parsedJson) {
    List<TeamSimple> teams = [];
    parsedJson['teams']
        .forEach((team) => {teams.add(TeamSimple.fromJson(team))});
    return TeamList(teams: teams);
  }
}
