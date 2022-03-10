import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/poke_strat_model.dart';

class DisplayDetailsStratWidgets extends StatefulWidget {
  final int gender;
  final PokeStrat poke;

  const DisplayDetailsStratWidgets({
    Key? key,
    required this.gender,
    required this.poke,
  }) : super(key: key);

  @override
  State<DisplayDetailsStratWidgets> createState() {
    return _DisplayDetailsStratWidgetsState(poke, gender);
  }
}

enum Gender { r, gl, m, f }

class _DisplayDetailsStratWidgetsState
    extends State<DisplayDetailsStratWidgets> {
  PokeStrat? _poke;
  Gender? _genderChoice = Gender.r;

  _DisplayDetailsStratWidgetsState(PokeStrat poke, int gender) {
    _poke = poke;
    _genderChoice = gender != -1 ? Gender.r : Gender.gl;
    controllerNickname.text = poke.nickName!;
  }

  TextEditingController controllerNickname = TextEditingController()..text = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0x00AA0000),
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFF343442),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        _poke!.nickName = value;
                      });
                    },
                    controller: controllerNickname,
                    autofocus: false,
                    style: const TextStyle(color: Color(0xFFFAFAFAf)),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nickname',
                      labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                      fillColor: Color(0x49202025),
                      filled: true,
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Text("Shiny"),
                    Switch(
                      value: _poke!.shiny!,
                      onChanged: (value) => setState(() {
                        _poke!.shiny = value;
                      }),
                      activeColor: Palette.kToDark.shade100,
                    )
                  ],
                )

                // SizedBox(
                //   width: 80,
                //   child: SwitchListTile(
                //     value: _poke!.shiny!,
                //     onChanged: (value) => setState(() {
                //       _poke!.shiny = value;
                //     }),
                //     title: Text("Shiny"),
                //   ),
                // ),
              ],
            ),
            Row(
              children: [
                const Text("Gender : "),
                Radio(
                    value: Gender.r,
                    groupValue: Gender,
                    onChanged: (value) {
                      setState(() {
                        _genderChoice = value as Gender?;
                      });
                    })
              ],
            )
          ]),
        ),
      ),
    );
  }
}
