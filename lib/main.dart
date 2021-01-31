import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _time = "0";
  int totaltime = 0;
  int laptime = 30;
  int laps = 0;
  var stopwatch = new Stopwatch();
  Timer timer;

  static AudioCache player = new AudioCache();

  void _set() {
    setState(() {
      totaltime = (stopwatch.elapsedMilliseconds / 1000).truncate();
    });
  }

  _update(Timer timer) {
    if (stopwatch.isRunning) {
      _time = getTime();
      if (laps < (totaltime / laptime).truncate()) {
        setState(() {
          laps++;
        });
        _ring();
      }
      _set();
    }
  }

  void start() {
    stopwatch.start();
    timer = new Timer.periodic(new Duration(milliseconds: 100), _update);
  }

  void stop() {
    stopwatch.stop();
    _set();
  }

  void _ring() {
    // SystemSound.play(SystemSoundType.click);
    player.play("crank.mp3");
  }

  String getTime() {
    return (totaltime % laptime).toString();
  }

  String getTotalTime() {
    return transformTime(totaltime);
  }

  transformTime(int secs) {
    int mins = (secs / 60).truncate();
    return (mins % 60).toString().padLeft(2, '0') +
        ":" +
        (secs % 60).toString().padLeft(2, '0');
  }

  _toggle() {
    if (stopwatch.isRunning) {
      stop();
    } else {
      start();
    }
  }

  _reset() {
    stop();
    stopwatch.reset();
    _set();
    setState(() {
      laps = 0;
    });
  }

  _change(int lapt) {
    setState(() {
      laptime = lapt;
    });
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController myController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Lap time',
            ),
            content: TextField(
              controller: myController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(myController.text.toString());
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: _toggle,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_time',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.3),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                ),
                Text(
                  getTotalTime(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.05),
                ),
                Text(
                  "Laps: " + laps.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: width * 0.05),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              createAlertDialog(context).then((onValue) {
                setState(() {
                  laptime = int.parse(onValue);
                  _reset();
                });
              });
            },
            tooltip: 'New',
            child: Icon(Icons.timer),
          ),
        ));
  }
}
