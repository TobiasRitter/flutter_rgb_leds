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
  bool editing = false;
  Color color = Colors.white;
  int alpha = 255;
  String lastValidRgb = "FFFFFF";
  TextEditingController controller = TextEditingController(text: "FFFFFF");
  String dropdownValue = "Custom";

  Color getRgbColor(String rgb) {
    String colorStr = "0xff" + rgb;
    return Color(int.parse(colorStr));
  }

  void submitCol(String rgb, BuildContext context) {
    try {
      var col = getRgbColor(rgb);
      setState(() {
        color = col;
        controller.text = rgb;
        lastValidRgb = rgb;
      });
    } catch (e) {
      controller.text = lastValidRgb;
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
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = ["Custom"] + widget.presets.keys.toList();
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
                color: color.withAlpha(alpha),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: Text("Connection"),
                leading: Icon(Icons.router_outlined),
                children: [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.all(0),
                title: Text("Color"),
                leading: Icon(Icons.palette),
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
                            if (widget.presets.containsKey(dropdownValue)) {
                              submitCol(widget.presets[dropdownValue], context);
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
                        widget.presets.containsKey(dropdownValue) && !editing
                            ? IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => setState(() => editing = true),
                              )
                            : editing
                                ? IconButton(
                                    icon: Icon(Icons.done),
                                    onPressed: () {
                                      setState(() => editing = false);
                                      submitCol(controller.text, context);
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
                          child: !widget.presets.containsKey(dropdownValue) ||
                                  editing
                              ? TextField(
                                  textAlign: TextAlign.center,
                                  controller: controller,
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
                                )
                              : TextField(
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  style: TextStyle(color: Colors.white38),
                                  decoration: InputDecoration(
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white38, width: 1),
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
