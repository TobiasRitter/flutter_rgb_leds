import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  Future<Map<String, String>> presets;
  bool editing = false;
  Color color;
  int alpha = 255;
  String lastValidRgb;
  TextEditingController colorController = TextEditingController();
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

  void submitCol(String rgb, BuildContext context) async {
    try {
      var col = getRgbColor(rgb).withAlpha(alpha);
      setState(() {
        color = col;
        colorController.text = rgb;
        lastValidRgb = rgb;
      });
      if (dropdownValue != "Custom" && !editing) {
        var _prefs = await prefs;
        _prefs.setString(dropdownValue, lastValidRgb);
        print("Setting $dropdownValue to $lastValidRgb");
      }
      presets = prefs.then(
        (value) => {
          "Preset 1": value.getString("Preset 1") ?? "FF0000",
          "Preset 2": value.getString("Preset 2") ?? "00FF00",
          "Preset 3": value.getString("Preset 3") ?? "0000FF",
        },
      );
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
    submitCol("FFFFFF", context);
  }

  @override
  void dispose() {
    super.dispose();
    colorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, String>>(
          future: presets,
          builder: (context, presetsSnapshot) {
            switch (presetsSnapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 0.5,
                            colors: [
                              color.withAlpha(
                                  (sqrt(alpha / 255) * 255 * 0.7).round()),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        if (dropdownValue != "Custom") {
                                          submitCol(
                                              presetsSnapshot
                                                  .data[dropdownValue],
                                              context);
                                        } else {
                                          submitCol("FFFFFF", context);
                                        }
                                      },
                                      items: (["Custom"] +
                                              presetsSnapshot.data.keys
                                                  .toList())
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
                                          onPressed: () =>
                                              setState(() => editing = true),
                                        )
                                      : editing
                                          ? IconButton(
                                              icon: Icon(Icons.done),
                                              onPressed: () {
                                                setState(() => editing = false);
                                                submitCol(colorController.text,
                                                    context);
                                              })
                                          : Container(
                                              width: 48,
                                              height: 48,
                                            ),
                                ],
                              ),
                              dropdownValue == "Custom" || editing
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: colorController,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white60,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
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
                                    color: Colors.white60,
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
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
