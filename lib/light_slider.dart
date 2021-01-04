import 'package:flutter/material.dart';

class LightSlider extends StatelessWidget {
  const LightSlider({
    Key key,
    @required this.alpha,
    @required this.color,
    @required this.onChanged,
    @required this.onMaxTap,
    @required this.onMinTap,
  }) : super(key: key);

  final int alpha;
  final Color color;
  final Function(double) onChanged;
  final Function() onMaxTap;
  final Function() onMinTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.nights_stay_outlined,
          ),
          onPressed: onMinTap,
        ),
        Expanded(
          child: Slider(
            value: alpha / 255,
            onChanged: onChanged,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.wb_sunny_outlined,
          ),
          onPressed: onMaxTap,
        ),
      ],
    );
  }
}
