import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          backgroundColor: Colors.blueGrey, brightness: Brightness.dark),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var laps = 0;
  var laptime = 30;
  var stopwatch = new Stopwatch();
  String time;
  Timer timer;

  @override
  void initState() {
    time = "00:00:01";
    super.initState();
  }

  update_time(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {
        time = transform_time(stopwatch.elapsedMilliseconds);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    start(20);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("$time",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 70,
                  color: Colors.white)),
          new Padding(padding: const EdgeInsets.all(20)),
          new Text((laps * laptime).toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[400])),
          new Padding(padding: const EdgeInsets.all(20)),
          new Text("Laps: " + laps.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[400])),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: setTime,
        tooltip: 'Inc',
        child: Icon(Icons.timelapse),
      ),
    );
  }

  transform_time(int millisecs) {
    var milisecs = stopwatch.elapsedMilliseconds;
    int millis = (milisecs / 10).truncate() % 100;
    int secs = (millis / 100).truncate() % 60;
    int mins = (secs / 60).truncate() % 60;
    return mins.toString() + ":" + secs.toString() + ":" + millis.toString();
  }

  void setTime() {
    var elapsed = stopwatch.elapsedMilliseconds;
    print('fskhfdsdfhdfaja hdfljasdfjas djfh asjdfasdfh');
    setState(() {
      time = "asdf";
    });
    print(time);
  }

  void start(int lapt) {
    laptime = lapt;
    stopwatch.start();
    time = "00:00:00";
    timer = new Timer.periodic(new Duration(milliseconds: 100), update_time);
  }

  void stop() {
    stopwatch.stop();
    setTime();
  }

  void reset() {
    stopwatch.reset();
    setTime();
  }
}
