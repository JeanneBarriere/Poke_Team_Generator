import 'package:flutter/material.dart';
import 'package:front/pages/generator_page.dart';
import 'package:front/pages/login_page.dart';
import 'package:front/pages/pokedex_page.dart';
import 'package:front/pages/list_team_page.dart';
import 'package:front/pages/register_page.dart';
import '../config/palette.dart';
import '../pages/search_pokemon_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'display_loader.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavigationDrawerWidget({Key? key}) : super(key: key);

  Future<SharedPreferences> _token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Palette.kToDark[400],
        child: FutureBuilder<SharedPreferences>(
            future: _token(),
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              SharedPreferences? prefs = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: DisplayLoader(size: 40));
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildMenuItem(
                            text: 'Search Pokemon',
                            icon: Icons.search,
                            onClicked: () => selectedItem(context, 0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildMenuItem(
                            text: 'Pokedex',
                            icon: Icons.book,
                            onClicked: () => selectedItem(context, 1),
                          ),
                        ),
                        if (prefs!.getString('token') != null)
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildMenuItem(
                                      text: 'Team',
                                      icon: Icons.table_view_outlined,
                                      onClicked: () =>
                                          selectedItem(context, 2))),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildMenuItem(
                                    text: 'Generate Team',
                                    icon: Icons.smart_toy_outlined,
                                    onClicked: () => {selectedItem(context, 5)},
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildMenuItem(
                                    text: 'Logout',
                                    icon: Icons.logout_outlined,
                                    onClicked: () => {
                                      prefs.remove('token'),
                                      selectedItem(context, 0)
                                    },
                                  )),
                            ],
                          )
                        else
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: buildMenuItem(
                                    text: 'Login',
                                    icon: Icons.login_outlined,
                                    onClicked: () => selectedItem(context, 3)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: buildMenuItem(
                                    text: 'Register',
                                    icon: Icons.account_circle_outlined,
                                    onClicked: () => selectedItem(context, 4)),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                default:
                  const Text('');
              }

              return ListView(
                children: const <Widget>[],
              );
            }),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    const hoverColor = Colors.white70;

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
              TeamListPage(key: UniqueKey(), title: "Your teams"),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginPage(key: UniqueKey(), title: "Login"),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              RegisterPage(key: UniqueKey(), title: "Register"),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GeneratorPage(key: UniqueKey()),
        ));
        break;
    }
  }
}
