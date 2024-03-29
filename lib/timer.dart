import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _currentTime = 0;
  int _totalTime = 0;
  bool _isRunning = false;
  Timer? _timer;
  bool _timeUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
      ),
      body: _timeUp
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Time\'s Up!',
                  style: TextStyle(fontSize: 32),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timeUp = false;
                      _currentTime = 0;
                      _totalTime = 0;
                      _isRunning = false;
                      _timer?.cancel();
                    });
                  },
                  child: Text('Restart'),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(_currentTime),
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _totalTime = int.parse(value);
                            _currentTime = _totalTime;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Total Time (seconds)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_isRunning) {
                            _isRunning = false;
                            _timer?.cancel();
                          } else if (_totalTime > 0) {
                            _currentTime = _totalTime;
                            _isRunning = true;
                            _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                              setState(() {
                                if (_currentTime > 0) {
                                  _currentTime--;
                                } else {
                                  _isRunning = false;
                                  _timer?.cancel();
                                  _timeUp = true;
                                }
                              });
                            });
                          }
                        });
                      },
                      child: Text(_isRunning ? 'Pause' : 'Start'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isRunning = false;
                          _timer?.cancel();
                          _currentTime = 0;
                          _totalTime = 0;
                          _timeUp = false;
                        });
                      },
                      child: Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.padLeft(8, '0');
  }
}