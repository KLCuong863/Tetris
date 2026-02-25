import 'package:flutter/material.dart';
import '../../manager/score_manager.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';


class HighScorePage extends StatefulWidget {
  const HighScorePage({super.key});

  @override
  State<HighScorePage> createState() => _HighScorePageState();
}

class _HighScorePageState extends State<HighScorePage> {

  int highScore = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final score = await ScoreManager.getHighScore();
    setState(() {
      highScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.boardBackground,
        title: const Text("HIGHSCORE"),
      ),
      body: Center(
        child: Text(
          "$highScore",
          style: AppFonts.pixeloidSemiBold40
              .copyWith(color: AppColors.pieceO),
        ),
      ),
    );
  }
}