import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/config/palette.dart';
import 'package:front/model/poke_strat_model.dart';
import 'package:front/widget/team/abilities_dropdown_button.dart';

class DisplayDetailsStratWidgets extends StatefulWidget {
  final int gender;
  final PokeStrat poke;
  final Function setLevel;
  final List<String> abilities;

  const DisplayDetailsStratWidgets({
    Key? key,
    required this.gender,
    required this.poke,
    required this.setLevel,
    required this.abilities,
  }) : super(key: key);

  @override
  State<DisplayDetailsStratWidgets> createState() {
    // ignore: no_logic_in_create_state
    return _DisplayDetailsStratWidgetsState(poke, gender, abilities[0]);
  }
}

enum Gender { r, gl, m, f }

class _DisplayDetailsStratWidgetsState
    extends State<DisplayDetailsStratWidgets> {
  PokeStrat? _poke;
  Gender? _genderChoice = Gender.r;
  int? _genderInfo = -1;

  _DisplayDetailsStratWidgetsState(PokeStrat poke, int gender, String ability) {
    _poke = poke;
    if (poke.ability == "") {
      _poke!.ability = ability;
    }
    _genderChoice = defineGender(gender);
    _genderInfo = gender;
    controllerNickname.text = poke.nickName!;
    controllerLevel.text = poke.level!.toString();
  }

  Gender defineGender(int gender) {
    switch (gender) {
      case -1:
        return Gender.gl;
      case 0:
        return Gender.m;
      case 8:
        return Gender.f;
      default:
        if (_poke!.gender == "F") return Gender.f;
        if (_poke!.gender == "M") return Gender.m;
        return Gender.r;
    }
  }

  TextEditingController controllerLevel = TextEditingController();
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
                    onChanged: (value) {
                      setState(() {
                        _poke!.nickName = value;
                      });
                    },
                    controller: controllerNickname,
                    autofocus: false,
                    // ignore: use_full_hex_values_for_flutter_colors
                    style: const TextStyle(color: Color(0xfffafafaf)),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nickname',
                      // ignore: use_full_hex_values_for_flutter_colors
                      labelStyle: TextStyle(color: Color(0xFFFAFAFAf)),
                      fillColor: Color(0x49202025),
                      filled: true,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    const Text("Shiny"),
                    Switch(
                      value: _poke!.shiny!,
                      onChanged: (value) => setState(() {
                        _poke!.shiny = value;
                      }),
                      activeColor: Palette.kToDark.shade100,
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                const Text("Level : "),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextField(
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                        // ignore: use_full_hex_values_for_flutter_colors
                        color: Color(0xFFFAFAFAf),
                        fontSize: 15),
                    controller: controllerLevel,
                    decoration: const InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(2.0),
                    ),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      int level = (double.parse(value).floor()).toInt();
                      if (level > 0 && level < 101) {
                        setState(() {
                          _poke!.level = level;
                        });
                        widget.setLevel(level);
                      } else {
                        controllerLevel.text = _poke!.level.toString();
                      }
                    },
                  ),
                ),
                const Spacer(),
                const Text("Ability : "),
                AbilitiesDropDownButton(
                  key: UniqueKey(),
                  index: _poke!.ability!,
                  onPress: (String? newValue) {
                    setState(() {
                      _poke!.ability = newValue!;
                    });
                  },
                  abilities: widget.abilities,
                ),
              ],
            ),
            const Text(
              "Gender",
              textAlign: TextAlign.center,
            ),
            _genderInfo! > -1
                ? Row(
                    children: [
                      Visibility(
                        visible: _genderInfo! > 0 && _genderInfo! < 8,
                        child: Radio<Gender>(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Palette.kToDark.shade200),
                            value: Gender.r,
                            groupValue: _genderChoice,
                            onChanged: (Gender? value) {
                              setState(() {
                                _genderChoice = value;
                                _poke!.gender = "";
                              });
                            }),
                      ),
                      Visibility(
                          visible: _genderInfo! > 0 && _genderInfo! < 8,
                          child: const Text("random")),
                      Visibility(
                        visible: _genderInfo! > 0,
                        child: Radio<Gender>(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Palette.kToDark.shade200),
                            value: Gender.f,
                            groupValue: _genderChoice,
                            onChanged: (Gender? value) {
                              setState(() {
                                _genderChoice = value;
                                _poke!.gender = "F";
                              });
                            }),
                      ),
                      Visibility(
                          visible: _genderInfo! > 0,
                          child: const Text("female")),
                      Visibility(
                        visible: _genderInfo! < 8,
                        child: Radio<Gender>(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => Palette.kToDark.shade200),
                            value: Gender.m,
                            groupValue: _genderChoice,
                            onChanged: (Gender? value) {
                              setState(() {
                                _genderChoice = value;
                                _poke!.gender = "M";
                              });
                            }),
                      ),
                      Visibility(
                          visible: _genderInfo! < 8, child: const Text("male")),
                    ],
                  )
                : Row(
                    children: [
                      Radio<Gender>(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Palette.kToDark.shade200),
                          value: Gender.gl,
                          groupValue: _genderChoice,
                          onChanged: (Gender? value) {}),
                      const Text("genderless"),
                    ],
                  )
          ]),
        ),
      ),
    );
  }
}
