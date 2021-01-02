import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rgb_leds/hex_field.dart';
import 'package:flutter_rgb_leds/light_bulb.dart';
import 'package:flutter_rgb_leds/light_slider.dart';
import 'package:flutter_rgb_leds/preset_selector.dart';
import 'package:flutter_rgb_leds/wifi_warning.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

const PORT = 15555;

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
        cursorColor: Colors.white,
        textSelectionColor: Colors.white38,
        textSelectionHandleColor: Colors.white,
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
  bool editing = true;
  Color color;
  int alpha = 255;
  String lastValidRgb;
  TextEditingController colorController = TextEditingController();
  String dropdownValue = "Custom";
  String wifiIP;
  HexField hexField;
  Container noHexField = Container();
  Widget displayedHexField;

  void broadcastCol(Color color, BuildContext context) async {
    try {
      var rgb = [color.alpha, color.red, color.green, color.blue];
      var rgbJson = jsonEncode(rgb);
      wifiIP = await WifiInfo().getWifiIP();
      assert(wifiIP != null);
      var ipSegments = wifiIP.split(".");
      var destinationStr =
          "${ipSegments[0]}.${ipSegments[1]}.${ipSegments[2]}.255";
      var destinationAddress = InternetAddress(destinationStr);

      RawDatagramSocket.bind(InternetAddress.anyIPv4, PORT)
          .then((RawDatagramSocket udpSocket) {
        udpSocket.broadcastEnabled = true;
        List<int> data = utf8.encode(rgbJson);
        udpSocket.send(data, destinationAddress, PORT);
        udpSocket.close();
      });
      print("broadcast: $rgb");
    } catch (e) {
      print(e);
    }
  }

  Color getRgbColor(String rgb) {
    rgb = rgb.toUpperCase();
    assert(rgb.length == 6);
    assert(matches(rgb, "[0-9A-F]+"));
    String colorStr = "0xff" + rgb;
    return Color(int.parse(colorStr));
  }

  void submitCol(String rgb, BuildContext context) {
    try {
      var col = getRgbColor(rgb).withAlpha(alpha);
      setState(() {
        color = col;
        lastValidRgb = rgb;
      });
      colorController.text = rgb;
      if (!editing) {
        presets.then((value) => value[dropdownValue] = rgb);
        prefs.then((SharedPreferences _prefs) {
          _prefs.setString(dropdownValue, rgb);
          print("Setting $dropdownValue to $rgb");
        });
      }
      broadcastCol(col, context);
    } catch (e) {
      colorController.text = lastValidRgb;
      Scaffold.of(context).showSnackBar(
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
    presets = prefs.then(
      (SharedPreferences _prefs) => {
        "Preset 1": _prefs.getString("Preset 1") ?? "FF0000",
        "Preset 2": _prefs.getString("Preset 2") ?? "00FF00",
        "Preset 3": _prefs.getString("Preset 3") ?? "0000FF",
      },
    );
    hexField = HexField(
      colorController: colorController,
      onSubmitted: submitCol,
    );
    displayedHexField = hexField;
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
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        color
                            .withAlpha((sqrt(alpha / 255) * 255 * 0.4).round()),
                        Colors.transparent
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        wifiIP == null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 48),
                                child: WifiWarning(),
                              )
                            : Container(),
                        LightBulb(color: color),
                        Padding(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: [
                                  PresetSelector(
                                    dropdownValue: dropdownValue,
                                    editing: editing,
                                    colorController: colorController,
                                    presetsSnapshot: presetsSnapshot,
                                    onEdit: () {
                                      setState(() {
                                        editing = true;
                                        displayedHexField = hexField;
                                      });
                                      submitCol(lastValidRgb, context);
                                    },
                                    onSave: () {
                                      setState(() {
                                        editing = false;
                                        displayedHexField = noHexField;
                                      });
                                      submitCol(colorController.text, context);
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        dropdownValue = val;
                                        editing = dropdownValue == "Custom";
                                        displayedHexField =
                                            dropdownValue == "Custom"
                                                ? hexField
                                                : noHexField;
                                      });
                                      submitCol(
                                          dropdownValue != "Custom"
                                              ? presetsSnapshot
                                                  .data[dropdownValue]
                                              : "FFFFFF",
                                          context);
                                    },
                                  ),
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 200),
                                    transitionBuilder: (child, animation) =>
                                        SizeTransition(
                                      sizeFactor: animation,
                                      child: child,
                                      axisAlignment: -1,
                                    ),
                                    child: displayedHexField,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: LightSlider(
                                  alpha: alpha,
                                  color: color,
                                  onChanged: (val) {
                                    setState(() {
                                      alpha = (val * 255).round();
                                      color = color.withAlpha(alpha);
                                    });
                                    broadcastCol(color, context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
