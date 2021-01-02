import 'package:flutter/material.dart';

class WifiWarning extends StatelessWidget {
  const WifiWarning({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off_outlined),
        Container(
          width: 16,
        ),
        Text("No WiFi connection")
      ],
    );
  }
}
