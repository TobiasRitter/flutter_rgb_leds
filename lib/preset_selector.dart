import 'package:flutter/material.dart';
import 'main.dart';

class PresetSelector extends StatelessWidget {
  const PresetSelector({
    Key key,
    @required this.dropdownValue,
    @required this.editing,
    @required this.colorController,
    @required this.onChanged,
    @required this.onEdit,
    @required this.onSave,
    @required this.presetsSnapshot,
  }) : super(key: key);

  final String dropdownValue;
  final bool editing;
  final TextEditingController colorController;
  final Function(String) onChanged;
  final Function() onEdit;
  final Function() onSave;
  final AsyncSnapshot<Map<String, String>> presetsSnapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 48,
          height: 48,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: DropdownButton<String>(
            underline: Container(),
            value: dropdownValue,
            onChanged: onChanged,
            items: (["Custom"] + presetsSnapshot.data.keys.toList())
                .map(
                  (k) => DropdownMenuItem(
                    value: k,
                    child: Center(child: Text(k)),
                  ),
                )
                .toList(),
          ),
        ),
        AnimatedSwitcher(
          duration: ANIMATION_DURATION,
          child: dropdownValue != "Custom"
              ? AnimatedSwitcher(
                  duration: ANIMATION_DURATION,
                  child: editing
                      ? IconButton(
                          key: ValueKey("saveButton"),
                          icon: Icon(Icons.done),
                          onPressed: onSave,
                        )
                      : IconButton(
                          key: ValueKey("editButton"),
                          icon: Icon(Icons.edit_outlined),
                          onPressed: onEdit,
                        ),
                )
              : Container(
                  width: 48,
                  height: 48,
                ),
        ),
      ],
    );
  }
}
