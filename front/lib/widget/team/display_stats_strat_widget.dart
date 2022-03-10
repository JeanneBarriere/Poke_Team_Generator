import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:front/model/poke_strat_model.dart';

class DisplayStatsStratWidgets extends StatefulWidget {
  final List<int?> baseStat;
  final PokeStrat poke;

  const DisplayStatsStratWidgets({
    Key? key,
    required this.baseStat,
    required this.poke,
  }) : super(key: key);

  @override
  State<DisplayStatsStratWidgets> createState() {
    return _DisplayStatsStratWidgetsState(poke);
  }
}

class _DisplayStatsStratWidgetsState extends State<DisplayStatsStratWidgets> {
  PokeStrat? _poke;

  _DisplayStatsStratWidgetsState(PokeStrat poke) {
    _poke = poke;
  }

  double statMaxPV(double stat, int level) {
    double result =
        ((((31 + 2 * stat + ((252 / 4).floor())) * level) / 100).floor()) +
            level +
            10;
    return (result.floor()).toDouble();
  }

  double statMax(double stat, int level) {
    double result =
        ((((31 + 2 * stat + ((252 / 4).floor())) * level) / 100).floor() + 5) *
            1.1;
    return (result.floor()).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    List<String> statsLabel = ["HP", "Atk", "Def", "SpA", "SpD", "Spe"];
    List<double> statsMax = [260, 185, 235, 180, 235, 200];
    Map<String, TextEditingController> controllersEv = {};
    TextEditingController _evHP = TextEditingController();
    TextEditingController _evAtk = TextEditingController();
    TextEditingController _evDef = TextEditingController();
    TextEditingController _evSpA = TextEditingController();
    TextEditingController _evSpD = TextEditingController();
    TextEditingController _evSpe = TextEditingController();

    controllersEv["HP"] = _evHP;
    controllersEv["Atk"] = _evAtk;
    controllersEv["Def"] = _evDef;
    controllersEv["SpA"] = _evSpA;
    controllersEv["SpD"] = _evSpD;
    controllersEv["Spe"] = _evSpe;

    Map<String, TextEditingController> controllersIv = {};
    TextEditingController _ivHP = TextEditingController();
    TextEditingController _ivAtk = TextEditingController();
    TextEditingController _ivDef = TextEditingController();
    TextEditingController _ivSpA = TextEditingController();
    TextEditingController _ivSpD = TextEditingController();
    TextEditingController _ivSpe = TextEditingController();

    controllersIv["HP"] = _ivHP;
    controllersIv["Atk"] = _ivAtk;
    controllersIv["Def"] = _ivDef;
    controllersIv["SpA"] = _ivSpA;
    controllersIv["SpD"] = _ivSpD;
    controllersIv["Spe"] = _ivSpe;

    for (int i = 0; i < 6; i++) {
      int value = widget.poke.evs![i].toInt();
      controllersEv[statsLabel[i]]!.text = value.toString();
      value = widget.poke.ivs![i].toInt();
      controllersIv[statsLabel[i]]!.text = value.toString();
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          children: widget.baseStat
              .asMap()
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0x00AA0000),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xFF343442),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                              height: 90,
                              width: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0x49202025),
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.zero,
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.zero),
                                  color: Color(0x49202025),
                                ),
                                child: Center(
                                  child: Text(
                                    statsLabel[entry.key],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Base : ${entry.value}",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        activeTrackColor: Colors.red[700],
                                        inactiveTrackColor:
                                            const Color(0x00000000),
                                        trackShape:
                                            const RoundedRectSliderTrackShape(),
                                        trackHeight: 2.0,
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 6.0),
                                        thumbColor: Colors.redAccent,
                                        overlayColor: Colors.red.withAlpha(32),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 10.0),
                                        tickMarkShape:
                                            const RoundSliderTickMarkShape(),
                                        activeTickMarkColor: Colors.red[700],
                                        inactiveTickMarkColor:
                                            const Color(0x00000000),
                                        valueIndicatorShape:
                                            const PaddleSliderValueIndicatorShape(),
                                        valueIndicatorColor: Colors.redAccent,
                                        valueIndicatorTextStyle:
                                            const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Slider(
                                        value: entry.value!.toDouble(),
                                        min: 0,
                                        max: statsLabel[entry.key] == "HP"
                                            ? statMaxPV(statsMax[entry.key],
                                                widget.poke.level!)
                                            : statMax(statsMax[entry.key],
                                                widget.poke.level!),
                                        divisions: 1,
                                        label: "${(entry.value!).floor()}",
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      "EV :",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 30,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: const TextStyle(
                                            color: Color(0xFFFAFAFAf),
                                            fontSize: 15),
                                        controller: controllersEv[
                                            statsLabel[entry.key]],
                                        decoration: const InputDecoration(
                                          hintText: "",
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.all(2.0),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onSubmitted: (value) {
                                          double stat =
                                              (double.parse(value).floor())
                                                  .toDouble();
                                          setState(() {
                                            _poke!.evs![entry.key] =
                                                stat >= 0 && stat <= 252
                                                    ? stat
                                                    : _poke!.ivs![entry.key];
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          activeTrackColor: Colors.red[700],
                                          inactiveTrackColor:
                                              const Color(0xFF777777),
                                          trackShape:
                                              const RoundedRectSliderTrackShape(),
                                          trackHeight: 2.0,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 6.0),
                                          thumbColor: Colors.redAccent,
                                          overlayColor:
                                              Colors.red.withAlpha(32),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                  overlayRadius: 10.0),
                                          tickMarkShape:
                                              const RoundSliderTickMarkShape(),
                                          activeTickMarkColor: Colors.red[700],
                                          inactiveTickMarkColor:
                                              const Color(0xFF777777),
                                          valueIndicatorShape:
                                              const PaddleSliderValueIndicatorShape(),
                                          valueIndicatorColor: Colors.redAccent,
                                          valueIndicatorTextStyle:
                                              const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Slider(
                                          value: widget.poke.evs![entry.key]
                                              .toDouble(),
                                          min: 0,
                                          max: 252,
                                          divisions: 5,
                                          label:
                                              "${widget.poke.evs![entry.key].floor()}",
                                          onChanged: (value) => setState(() {
                                            _poke!.evs![entry.key] = value;
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      "IV : ",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 30,
                                      child: TextField(
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          style: const TextStyle(
                                            color: Color(0xFFFAFAFAf),
                                            fontSize: 15,
                                          ),
                                          controller: controllersIv[
                                              statsLabel[entry.key]],
                                          decoration: const InputDecoration(
                                            hintText: "",
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.all(2.0),
                                          ),
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (value) {
                                            double stat =
                                                (double.parse(value).floor())
                                                    .toDouble();
                                            setState(() {
                                              _poke!.ivs![entry.key] =
                                                  stat >= 0 && stat <= 31
                                                      ? stat
                                                      : _poke!.ivs![entry.key];
                                            });
                                          }),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          activeTrackColor: Colors.red[700],
                                          inactiveTrackColor:
                                              const Color(0xFF777777),
                                          trackShape:
                                              const RoundedRectSliderTrackShape(),
                                          trackHeight: 2.0,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 6.0),
                                          thumbColor: Colors.redAccent,
                                          overlayColor:
                                              Colors.red.withAlpha(32),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                  overlayRadius: 10.0),
                                          tickMarkShape:
                                              const RoundSliderTickMarkShape(),
                                          activeTickMarkColor: Colors.red[700],
                                          inactiveTickMarkColor:
                                              const Color(0xFF777777),
                                          valueIndicatorShape:
                                              const PaddleSliderValueIndicatorShape(),
                                          valueIndicatorColor: Colors.redAccent,
                                          valueIndicatorTextStyle:
                                              const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Slider(
                                            value: widget.poke.ivs![entry.key]
                                                .toDouble(),
                                            min: 0,
                                            max: 31,
                                            divisions: 31,
                                            label:
                                                "${(widget.poke.ivs![entry.key]).floor()}",
                                            onChanged: (double value) =>
                                                setState(() {
                                                  _poke!.ivs![entry.key] =
                                                      value;
                                                })),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}
