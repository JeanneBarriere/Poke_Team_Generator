import 'package:flutter/material.dart';
import 'package:front/config/palette.dart';

class DisplayLoader extends StatefulWidget {
  final double size;
  const DisplayLoader({Key? key, required this.size}) : super(key: key);

  @override
  State<DisplayLoader> createState() => _DisplayLoaderState();
}

class _DisplayLoaderState extends State<DisplayLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCirc,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: RotationTransition(
          turns: _animation,
          child: Icon(
            Icons.catching_pokemon,
            color: Palette.kToDark.shade300,
            size: widget.size,
          ),
        ));
  }
}
