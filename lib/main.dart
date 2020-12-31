import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

const TextStyle textStyle = TextStyle(
    // fontWeight: FontWeight.w300,
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool editing = false;
  Color color = Colors.white;
  int alpha = 255;
  Map<String, String> presets = {
    "Preset1": "FF0000",
    "Preset2": "00FF00",
    "Preset3": "0000FF",
  };
  TextEditingController controller;
  String dropdownValue = "Custom";

  Color getRgbColor(String rgb) {
    String colorStr = "0xff" + rgb;
    return Color(int.parse(colorStr));
  }

  void submitCol(String val, BuildContext context) {
    try {
      var col = getRgbColor(val);
      setState(() {
        color = col;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid color code"),
        ),
      );
    }
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
                color: color.withAlpha(alpha),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButton<String>(
                underline: Container(),
                value: dropdownValue,
                onChanged: (val) {
                  setState(() {
                    dropdownValue = val;
                    editing = false;
                    if (presets.containsKey(dropdownValue)) {
                      submitCol(presets[dropdownValue], context);
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    child: Text("#"),
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      enabled: !presets.containsKey(dropdownValue) || editing,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "FFFFFF",
                        border: InputBorder.none,
                      ),
                      style: textStyle,
                      onSubmitted: (val) {
                        submitCol(val, context);
                      },
                    ),
                  ),
                  presets.containsKey(dropdownValue) && !editing
                      ? IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => setState(() => editing = true),
                        )
                      : editing
                          ? IconButton(
                              icon: Icon(Icons.done),
                              onPressed: () => setState(() {
                                    editing = false;
                                  }))
                          : Container(),
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
