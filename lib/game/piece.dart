import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tetris_flame/game/tetris.dart';
import 'dart:math';

import '../utils/colors.dart';


class Piece {
  List<List<int>> shape;
  final Color color;

  int x; // grid column
  int y; // grid row

  Piece({
    required this.shape,
    required this.color,
    required this.x,
    required this.y,
  });

  int get width => shape[0].length;
  int get height => shape.length;
}

class CurrentPieceComponent extends PositionComponent {
  final TetrisGame game;

  CurrentPieceComponent(this.game);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final piece = game.currentPiece;

    final paint = Paint()..color = piece.color;

    for (int row = 0; row < piece.shape.length; row++) {
      for (int col = 0; col < piece.shape[row].length; col++) {
        if (piece.shape[row][col] == 1) {
          final boardX = piece.x + col;
          final boardY = piece.y + row;

          final pixelX =
              game.boardOffsetX + boardX * game.blockSize;
          final pixelY =
              game.boardOffsetY + boardY * game.blockSize;

          canvas.drawRect(
            Rect.fromLTWH(
              pixelX,
              pixelY,
              game.blockSize,
              game.blockSize,
            ),
            paint,
          );
        }
      }
    }
  }
}

enum PieceType { I, O, T, L, J, S, Z }

final Random _random = Random();
List<PieceType> _bag = [];

void _refillBag() {
  _bag = PieceType.values.toList();
  _bag.shuffle(_random);
}

PieceType _getNextPieceType() {
  if (_bag.isEmpty) {
    _refillBag();
  }

  return _bag.removeLast();
}

List<List<int>> _getShape(PieceType type) {
  switch (type) {
    case PieceType.I:
      return [
        [1, 1, 1, 1],
      ];

    case PieceType.O:
      return [
        [1, 1],
        [1, 1],
      ];

    case PieceType.T:
      return [
        [0, 1, 0],
        [1, 1, 1],
      ];

    case PieceType.L:
      return [
        [0, 0, 1],
        [1, 1, 1],
      ];

    case PieceType.J:
      return [
        [1, 0, 0],
        [1, 1, 1],
      ];

    case PieceType.S:
      return [
        [0, 1, 1],
        [1, 1, 0],
      ];

    case PieceType.Z:
      return [
        [1, 1, 0],
        [0, 1, 1],
      ];
  }
}

Color _getColor(PieceType type) {
  switch (type) {
    case PieceType.I:
      return AppColors.pieceI;
    case PieceType.O:
      return AppColors.pieceO;
    case PieceType.T:
      return AppColors.pieceT;
    case PieceType.L:
      return AppColors.pieceL;
    case PieceType.J:
      return AppColors.pieceJ;
    case PieceType.S:
      return AppColors.pieceS;
    case PieceType.Z:
      return AppColors.pieceZ;
  }
}

Piece createNextPiece(int boardCols) {
  final type = _getNextPieceType();

  final shape = _getShape(type);
  final spawnX = (boardCols - shape[0].length) ~/ 2;

  return Piece(
    shape: shape,
    color: _getColor(type),
    x: spawnX,
    y: 0,
  );
}

