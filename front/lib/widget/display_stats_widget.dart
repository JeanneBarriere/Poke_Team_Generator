import 'package:flutter/material.dart';

class DisplayStatsWidgets extends StatelessWidget {
  final List<int?> stats;

  const DisplayStatsWidgets({Key? key, required this.stats}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> statsLabel = [
      "HP",
      "Attack",
      "Defense",
      "Sp. Atk",
      "Sp. Def",
      "Speed"
    ];
    List<double> statsMax = [260, 185, 235, 180, 235, 200];
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          children: statsLabel
              .map((item) => Row(
                    children: [
                      SizedBox(width: 75, child: Text(item + ":")),
                      SizedBox(
                          width: 50,
                          child: Text(
                            "${stats[statsLabel.indexOf(item)]}",
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Colors.red[700],
                            inactiveTrackColor: Colors.red[100],
                            trackShape: const RoundedRectSliderTrackShape(),
                            trackHeight: 2.0,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6.0),
                            thumbColor: Colors.redAccent,
                            overlayColor: Colors.red.withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 10.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.red[700],
                            inactiveTickMarkColor: Colors.red[100],
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.redAccent,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            value: stats[statsLabel.indexOf(item)]!.toDouble(),
                            min: 0,
                            max: statsMax[statsLabel.indexOf(item)],
                            divisions: 5,
                            label: "${stats[statsLabel.indexOf(item)]}",
                            onChanged: (value) {},
                          ),
                        ),
                      )
                    ],
                  ))
              .toList()),
    );
  }
}
