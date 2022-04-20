// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/palette.dart';
import './pages/search_pokemon_page.dart';

//package get pour état global

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Teams Generator',
        theme: ThemeData(
          cardColor: Palette.kToDark.shade300,
          scaffoldBackgroundColor: const Color(0xFF020202f),
          primarySwatch: Palette.kToDark,
          fontFamily: GoogleFonts.nunito().fontFamily,
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            headline3: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            headline5: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            bodyText2: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
          ).apply(
            bodyColor: const Color(0xFF888888f),
            displayColor: const Color(0xFF888888f),
          ),
        ),
        home: SearchPokemonPage(key: UniqueKey(), title: 'Search Pokemon'),
        debugShowCheckedModeBanner: false);
  }
}
