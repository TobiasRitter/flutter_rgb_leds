import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB Light Control',
      theme: ThemeData(
        fontFamily: 'Raleway',
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white38,
          selectionHandleColor: Colors.white,
        ),
        sliderTheme: SliderThemeData(
          thumbColor: Colors.white,
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.black,
          overlayColor: Colors.white38,
        ),
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final Map<String, String> presets = {
    "Preset 1": "FF0000",
    "Preset 2": "00FF00",
    "Preset 3": "0000FF",
  };

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool editing = false;
  Color color;
  int alpha = 255;
  String lastValidRgb;
  TextEditingController colorController;
  String dropdownValue = "Custom";

  Color getRgbColor(String rgb) {
    String colorStr = "0xff" + rgb;
    return Color(int.parse(colorStr));
  }

  void broadcastCol(Color color) {
    // TODO: implement
    List<int> rgb = [color.alpha, color.red, color.green, color.blue];
    print("broadcast: $rgb");
  }

  void submitCol(String rgb, BuildContext context) {
    try {
      var col = getRgbColor(rgb).withAlpha(alpha);
      setState(() {
        color = col;
        colorController.text = rgb;
        lastValidRgb = rgb;
      });
      broadcastCol(color);
    } catch (e) {
      colorController.text = lastValidRgb;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid color code"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    colorController = TextEditingController();
    submitCol("FFFFFF", context);
  }

  @override
  void dispose() {
    super.dispose();
    colorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ["Custom"] + widget.presets.keys.toList();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.5,
                  colors: [
                    color.withAlpha((sqrt(alpha / 255) * 255 * 0.7).round()),
                    Colors.transparent
                  ],
                ),
              ),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    Row(
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
                            onChanged: (val) {
                              setState(() {
                                dropdownValue = val;
                                editing = false;
                              });
                              if (widget.presets.containsKey(dropdownValue)) {
                                submitCol(
                                    widget.presets[dropdownValue], context);
                              } else {
                                submitCol("FFFFFF", context);
                              }
                            },
                            items: options
                                .map(
                                  (k) => DropdownMenuItem(
                                    value: k,
                                    child: Center(child: Text(k)),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        widget.presets.containsKey(dropdownValue) && !editing
                            ? IconButton(
                                icon: Icon(Icons.edit_outlined),
                                onPressed: () => setState(() => editing = true),
                              )
                            : editing
                                ? IconButton(
                                    icon: Icon(Icons.done),
                                    onPressed: () {
                                      setState(() => editing = false);
                                      submitCol(colorController.text, context);
                                    })
                                : Container(
                                    width: 48,
                                    height: 48,
                                  ),
                      ],
                    ),
                    !widget.presets.containsKey(dropdownValue) || editing
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: colorController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white38, width: 1),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      labelText: "#",
                                    ),
                                    onSubmitted: (val) {
                                      submitCol(val, context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.nights_stay_outlined,
                          color: Colors.white38,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                            value: alpha / 255,
                            onChanged: (val) {
                              setState(() {
                                alpha = (val * 255).round();
                                color = color.withAlpha(alpha);
                              });
                              broadcastCol(color);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
