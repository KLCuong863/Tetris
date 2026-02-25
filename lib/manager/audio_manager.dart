import 'package:flutter/material.dart';

class AudioManager extends ChangeNotifier {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  double volume = 0.5;

  void setVolume(double value) {
    volume = value;
    notifyListeners();
  }
}