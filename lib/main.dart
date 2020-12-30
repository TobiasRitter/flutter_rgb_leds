import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white10,
          selectionHandleColor: Colors.white,
        ),
        sliderTheme: SliderThemeData(
          thumbColor: Colors.white,
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.black,
          overlayColor: Colors.white10,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int alpha = 0;
  List<int> rgb = [255, 255, 255];
  Map<String, List<int>> presets = {
    "Preset1": [255, 0, 0],
    "Preset2": [255, 255, 0],
    "Preset3": [0, 0, 255],
  };
  TextEditingController rController;
  TextEditingController gController;
  TextEditingController bController;
  String dropdownValue = "Custom";

  void callback(int change, TextEditingController controller) {
    if (int.tryParse(controller.text) != null) {
      int val = int.parse(controller.text) + change;
      print(val);
      if (val >= 0 && val <= 255) {
        setState(() => controller.text = val.toString());
      }
    }
  }

  void callback2(TextEditingController controller, int index) {
    var str = controller.text;
    if (int.tryParse(str) != null &&
        int.parse(str) >= 0 &&
        int.parse(str) <= 255) {
      rgb[index] = int.parse(str);
    } else {
      setState(() {
        controller.text = rgb[index].toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    rController = TextEditingController(text: rgb[0].toString());
    gController = TextEditingController(text: rgb[1].toString());
    bController = TextEditingController(text: rgb[2].toString());
    rController.addListener(() => callback2(rController, 0));
    gController.addListener(() => callback2(gController, 1));
    bController.addListener(() => callback2(bController, 2));
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ["Custom"] + presets.keys.toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Icon(
                Icons.lightbulb_outline,
                size: 128,
                color: Color.fromARGB(
                  255,
                  (rgb[0] * alpha / 255).round(),
                  (rgb[1] * alpha / 255).round(),
                  (rgb[2] * alpha / 255).round(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  DropdownButton<String>(
                    underline: Container(),
                    value: dropdownValue,
                    onChanged: (val) {
                      setState(() {
                        dropdownValue = val;
                        if (presets.containsKey(dropdownValue)) {
                          rgb = presets[dropdownValue];
                        }
                      });
                    },
                    items: options
                        .map(
                          (k) => DropdownMenuItem(
                            value: k,
                            child: Text(k),
                          ),
                        )
                        .toList(),
                  ),
                  Spacer(),
                  presets.containsKey(dropdownValue)
                      ? IconButton(icon: Icon(Icons.edit), onPressed: null)
                      : Container(),
                ],
              ),
            ),
            presets.containsKey(dropdownValue)
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        RGBValPicker(
                          label: "R",
                          callback: (val) => callback(val, rController),
                          controller: rController,
                        ),
                        RGBValPicker(
                          label: "G",
                          callback: (val) => callback(val, gController),
                          controller: gController,
                        ),
                        RGBValPicker(
                          label: "B",
                          callback: (val) => callback(val, bController),
                          controller: bController,
                        ),
                      ],
                    ),
                  ),
            Row(
              children: [
                Icon(Icons.nights_stay_outlined),
                Expanded(
                  child: Slider(
                      value: alpha / 255,
                      onChanged: (val) {
                        setState(() {
                          alpha = (val * 255).round();
                        });
                      }),
                ),
                Icon(Icons.wb_sunny_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RGBValPicker extends StatelessWidget {
  const RGBValPicker({
    Key key,
    @required this.label,
    @required this.callback,
    @required this.controller,
  })  : assert(label != null),
        assert(callback != null),
        assert(controller != null),
        super(key: key);

  final String label;
  final Function(int) callback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 28,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: controller.text == "255" ? null : () => callback(1),
        ),
        Container(
          width: 100,
          child: TextField(
            style: TextStyle(fontWeight: FontWeight.w100),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            controller: controller,
            // onTap: () => controller.selection = TextSelection(
            //     baseOffset: 0, extentOffset: controller.value.text.length),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: controller.text == "0" ? null : () => callback(-1),
        ),
      ],
    );
  }
}
