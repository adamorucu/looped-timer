import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  String _time = "00:00";
  int laptime = 30;
  var stopwatch = new Stopwatch();
  Timer timer;

  void _set() {
    setState(() {
      _time = transformTime(stopwatch.elapsedMilliseconds);
    });
  }

  _update(Timer timer) {
    if (stopwatch.isRunning) {
      int elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed >= laptime * 1000) {
        stopwatch.reset();
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
    SystemSound.play(SystemSoundType.click);
  }

  transformTime(int militime) {
    int secs = (militime / 1000).truncate();
    int mins = (secs / 60).truncate();
    return (mins % 60).toString().padLeft(2, '0') +
        ":" +
        (secs % 60).toString().padLeft(2, '0');
  }

  _toggle() {
    print('tap');
    if (stopwatch.isRunning) {
      print('stop');
      stop();
    } else {
      print('start');
      start();
    }
  }

  _reset() {
    stop();
    stopwatch.reset();
    _set();
  }

  _change(int lapt) {
    setState(() {
      laptime = lapt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _toggle,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_time',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _reset,
            tooltip: 'Increment',
            child: Icon(Icons.timer),
          ),
        ));
  }
}
