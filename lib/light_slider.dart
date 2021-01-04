import 'package:flutter/material.dart';
import 'package:flutter_rgb_leds/main.dart';

class LightSlider extends StatefulWidget {
  const LightSlider({
    Key key,
    @required this.alpha,
    @required this.onChanged,
  }) : super(key: key);

  final double alpha;
  final Function(double) onChanged;

  @override
  _LightSliderState createState() => _LightSliderState();
}

class _LightSliderState extends State<LightSlider>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      value: widget.alpha,
      duration: ANIMATION_DURATION,
      vsync: this,
    );
    animationController
        .addListener(() => widget.onChanged(animationController.value));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.nights_stay_outlined,
          ),
          onPressed: () => animationController.animateTo(0),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: animationController,
            builder: (_, __) => Slider(
              value: animationController.value,
              onChanged: (val) => animationController.value = val,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.wb_sunny_outlined,
          ),
          onPressed: () => animationController.animateTo(1),
        ),
      ],
    );
  }
}
