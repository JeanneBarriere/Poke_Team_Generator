// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:front/model/team_model.dart';

class TeamTitle extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const TeamTitle({Key? key, required this.controller, required this.team});

  final TextEditingController controller;
  final Team team;

  @override
  State<TeamTitle> createState() => _TeamTitleState();
}

class _TeamTitleState extends State<TeamTitle> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) => setState(() {
        widget.team.newTitle = value;
      }),
      autofocus: false,
      style: const TextStyle(color: Color(0xfffafafaf)),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Title of Team',
        labelStyle: TextStyle(color: Color(0xfffafafaf)),
        fillColor: Color(0xff333333f),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCF1B1B)),
        ),
      ),
    );
  }
}
