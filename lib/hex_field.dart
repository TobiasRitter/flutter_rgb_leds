import 'package:flutter/material.dart';

class HexField extends StatelessWidget {
  const HexField({
    Key key,
    @required this.colorController,
    @required this.onSubmitted,
  }) : super(key: key);

  final TextEditingController colorController;
  final Function(String, BuildContext) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              controller: colorController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                labelText: "#",
              ),
              onSubmitted: (val) {
                onSubmitted(val, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
