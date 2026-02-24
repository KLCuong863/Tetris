import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_flame/pages/home%20page/home_page.dart';
import 'package:tetris_flame/utils/colors.dart';
import 'package:tetris_flame/utils/fonts.dart';
import 'package:tetris_flame/widgets/app_title.dart';
import 'package:tetris_flame/widgets/custom_page.dart';
import 'package:flame/game.dart';

import '../../game/tetris.dart';

class GameScreen extends StatefulWidget{

  const GameScreen({super.key});
  @override
  State<StatefulWidget> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>{
  final TetrisGame _game = TetrisGame();

  Widget _buildHUD(TetrisGame game) {
    return AnimatedBuilder(
      animation: game,
      builder: (context, _) {
        return Positioned(
          top: 40,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Score: ${game.score}",
                  style: const TextStyle(color: Colors.white)),
              Text("Level: ${game.level}",
                  style: const TextStyle(color: Colors.white)),
              Text("Lines: ${game.totalLines}",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      widget: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gameBg,
        ),
        child: Column(
          children: [

            Expanded(
              child: GameWidget(
                game: _game,
                overlayBuilderMap: {
                  'HUD': (context, game) {
                    return _buildHUD(game as TetrisGame);
                  },
                  'Pause': (context, game) {
                    return Center(
                      child: Container(
                        color: Colors.black54,
                        child: const Text(
                          "PAUSED",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    );
                  },
                  'GameOver': (context, game) {
                    final g = game as TetrisGame;

                    return Center(
                      child: Container(
                        color: Colors.black87,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "GAME OVER",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            Text(
                              "Score: ${g.score}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  g.resetGame();
                                },
                                child: const Text("Restart"),
                              ),
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: 200,
                              child: OutlinedButton(
                                onPressed: () {
                                  g.overlays.remove('GameOver');
                                  context.pop();
                                },
                                child: const Text(
                                  "Back to Home",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                },
                initialActiveOverlays: const ['HUD'],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: AppTitle(style: AppFonts.pixeloidSemiBold16,),
            )
          ],
        )

      ),
    );
  }

}

