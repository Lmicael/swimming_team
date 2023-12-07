import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronômetro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headline3: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      home: stopwatch(),
    );
  }
}

class stopwatch extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<stopwatch> {
  bool isRunning = false;
  int seconds = 0;
  List<int> pauses = [];
  List<Color> pauseColors = [Color(0xFF34C1F9), Color(0xFF2698D6)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 45, 78),
      appBar: AppBar(
        title: Text('Cronômetro'),
        backgroundColor: Color.fromARGB(255, 3, 5, 56),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatTime(seconds),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                      if (isRunning) {
                        startTimer();
                      } else {
                        pauses.add(seconds);
                      }
                    });
                  },
                  iconSize: 36,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      isRunning = false;
                      seconds = 0;
                      pauses.clear();
                    });
                  },
                  iconSize: 36,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              height: 230,
              child: ListView.builder(
                itemCount: pauses.length,
                itemBuilder: (context, index) {
                  int pause = pauses[index];
                  Color pauseColor = pauseColors[index % pauseColors.length];

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${formatTime(pause)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              pauses.removeAt(index);
                            });
                          },
                        ),
                      ),
                      Divider(
                        height: 3,
                        color: Colors.grey[400],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (pauses.isNotEmpty) {
                  Navigator.pushNamed(context, '/RF004', arguments: pauses);
                } else {
                  _showNoPausesDialog();
                }
              },
              child: Text(
                'Salvar Pausas',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      } else {
        setState(() {
          seconds++;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pausas'),
          content: Text('Salvas com Sucesso'),
          actions: [
            TextButton(
              onPressed: () {
                print(pauses);
                setState(() {
                  pauses.clear();
                  seconds = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showNoPausesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nenhuma Pausa'),
          content: Text('Não há pausas para salvar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
