import 'package:flutter/material.dart';

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
        dropdownValue != "Custom" && !editing
            ? IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: onEdit,
              )
            : editing
                ? IconButton(
                    icon: Icon(Icons.done),
                    onPressed: onSave,
                  )
                : Container(
                    width: 48,
                    height: 48,
                  ),
      ],
    );
  }
}
