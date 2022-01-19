import 'package:flutter/material.dart';
import 'package:front/pages/pokedex_page.dart';
import 'package:front/pages/list_team_page.dart';
import '../config/palette.dart';
import '../pages/search_pokemon_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Palette.kToDark[400],
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            buildMenuItem(
              text: 'Search Pokemon',
              icon: Icons.search,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              text: 'Pokedex',
              icon: Icons.book,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 20),
            buildMenuItem(
                text: 'Team',
                icon: Icons.table_view_outlined,
                onClicked: () => selectedItem(context, 2))
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color, fontSize: 20.0)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              SearchPokemonPage(key: UniqueKey(), title: "Search Pokemon"),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PokedexPage(key: UniqueKey(), title: "Pokedex"),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TeamListPage(key: UniqueKey(), title: "Pokedex"),
        ));
        break;
    }
  }
}
