import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static const _key = "high_score";

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_key) ?? 0;

    if (score > current) {
      await prefs.setInt(_key, score);
    }
  }
}