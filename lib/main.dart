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
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
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
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final Map<String, String> presets = {
    "Preset1": "FF0000",
    "Preset2": "00FF00",
    "Preset3": "0000FF",
  };

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool routerSettingsOpened = false;
  bool colorSettingsOpened = false;
  bool editing = false;
  Color color = Colors.white;
  int alpha = 255;
  String lastValidRgb = "FFFFFF";
  TextEditingController colorController = TextEditingController(text: "FFFFFF");
  TextEditingController ipController = TextEditingController(text: "0.0.0.0");
  String dropdownValue = "Custom";

  Color getRgbColor(String rgb) {
    String colorStr = "0xff" + rgb;
    return Color(int.parse(colorStr));
  }

  void submitIP(String ip, BuildContext context) {
    // TODO: implement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Invalid ip address"),
      ),
    );
  }

  void submitCol(String rgb, BuildContext context) {
    try {
      var col = getRgbColor(rgb);
      setState(() {
        color = col;
        colorController.text = rgb;
        lastValidRgb = rgb;
      });
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
                  radius: 1,
                  colors: [
                    color.withAlpha((alpha / 2).floor()),
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
                    color: color.withAlpha(alpha),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.router,
                          color: routerSettingsOpened
                              ? Colors.white
                              : Colors.white38,
                        ),
                        onPressed: () {
                          setState(() {
                            routerSettingsOpened = !routerSettingsOpened;
                            colorSettingsOpened = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.palette,
                          color: colorSettingsOpened
                              ? Colors.white
                              : Colors.white38,
                        ),
                        onPressed: () {
                          setState(() {
                            colorSettingsOpened = !colorSettingsOpened;
                            routerSettingsOpened = false;
                          });
                        },
                      )
                    ],
                  ),
                ),
                routerSettingsOpened
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: ipController,
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
                                      labelText: "IPv4:",
                                    ),
                                    onSubmitted: (val) {
                                      submitIP(val, context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                colorSettingsOpened
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton<String>(
                                  underline: Container(),
                                  value: dropdownValue,
                                  onChanged: (val) {
                                    setState(() {
                                      dropdownValue = val;
                                      editing = false;
                                    });
                                    if (widget.presets
                                        .containsKey(dropdownValue)) {
                                      submitCol(widget.presets[dropdownValue],
                                          context);
                                    } else {
                                      submitCol("FFFFFF", context);
                                    }
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
                                widget.presets.containsKey(dropdownValue) &&
                                        !editing
                                    ? IconButton(
                                        icon: Icon(Icons.edit),
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
                                        : Container(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: !widget.presets
                                              .containsKey(dropdownValue) ||
                                          editing
                                      ? TextField(
                                          textAlign: TextAlign.center,
                                          controller: colorController,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white38,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            labelText: "#",
                                          ),
                                          onSubmitted: (val) {
                                            submitCol(val, context);
                                          },
                                        )
                                      : TextField(
                                          textAlign: TextAlign.center,
                                          controller: colorController,
                                          enabled: false,
                                          style:
                                              TextStyle(color: Colors.white38),
                                          decoration: InputDecoration(
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white38,
                                                  width: 1),
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
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.nights_stay_outlined),
                    ),
                    Expanded(
                      child: Slider(
                          value: alpha / 255,
                          onChanged: (val) {
                            setState(() {
                              alpha = (val * 255).round();
                            });
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.wb_sunny_outlined),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
