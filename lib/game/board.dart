import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tetris_flame/game/tetris.dart';

import '../utils/colors.dart';

class BoardComponent extends PositionComponent {
  final TetrisGame game;

  BoardComponent(this.game);

  @override
  Future<void> onLoad() async {
    size = game.size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final strokePaint = Paint()
      ..color = AppColors.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final blockPaint = Paint()
      ..color = AppColors.primary;

    for (int row = 0; row < TetrisGame.rows; row++) {
      for (int col = 0; col < TetrisGame.cols; col++) {
        final x = game.boardOffsetX + col * game.blockSize;
        final y = game.boardOffsetY + row * game.blockSize;

        // Draw grid
        canvas.drawRect(
          Rect.fromLTWH(x, y, game.blockSize, game.blockSize),
          strokePaint,
        );

        // Draw block nếu có
        if (game.board[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, game.blockSize, game.blockSize),
            blockPaint,
          );
        }
      }
    }
  }
}