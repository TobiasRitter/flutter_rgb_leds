import 'package:flutter/material.dart';

class LightSlider extends StatelessWidget {
  const LightSlider({
    Key key,
    @required this.alpha,
    @required this.color,
    @required this.onChanged,
  }) : super(key: key);

  final int alpha;
  final Color color;
  final Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.nights_stay_outlined,
              color: Colors.white60,
            ),
          ),
          Expanded(
            child: Slider(
              value: alpha / 255,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.wb_sunny_outlined,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
