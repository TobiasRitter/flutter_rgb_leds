import 'package:flutter/material.dart';

class LightBulb extends StatelessWidget {
  const LightBulb({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 128,
            color: color.withAlpha(255),
          ),
        ],
      ),
    );
  }
}
