

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_flame/game/piece.dart';

import '../utils/colors.dart';
import 'board.dart';

class TetrisGame extends FlameGame with KeyboardEvents, ChangeNotifier{
  ///SCORE & LEVEL
  int score = 0;
  int totalLines = 0;
  int level = 1;
  ///BOARD
  late List<List<int>> board;
  static const int rows = 20;
  static const int cols = 10;
  late double blockSize;
  late double boardOffsetX;
  late double boardOffsetY;
  ///PIECE
  late Piece currentPiece;
  double dropTimer = 0;
  double dropInterval = 0.5; // 0.5 giây

  bool isGameOver = false;
  bool isPaused = false;

  bool isSoftDropping = false;
  double normalDropSpeed = 0.5;
  final double softDropSpeed = 0.05;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  void update(double dt) {
    if (isGameOver || isPaused) return;
    if (isGameOver) return;

    super.update(dt);

    dropTimer += dt;

    final currentInterval =
    isSoftDropping ? softDropSpeed : normalDropSpeed;

    if (dropTimer >= currentInterval) {
      dropTimer = 0;
      _movePieceDown();
    }
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    _caculateBoardSize();
    _initBoard();
    currentPiece = createNextPiece(cols);
    add(CurrentPieceComponent(this));
    add(BoardComponent(this));
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    if (event is KeyDownEvent) {

      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _movePiece(-1);

      } else if (event.logicalKey ==
          LogicalKeyboardKey.arrowRight) {
        _movePiece(1);

      } else if (event.logicalKey ==
          LogicalKeyboardKey.arrowDown) {

        // 🔥 giữ để rơi nhanh
        isSoftDropping = true;

      } else if (event.logicalKey ==
          LogicalKeyboardKey.space) {

        // 🔥 space = hard drop (chuẩn Tetris PC)
        _hardDrop();

      } else if (event.logicalKey ==
          LogicalKeyboardKey.arrowUp) {
        _rotatePiece();
      }
    }

    // 👇 khi thả phím xuống
    if (event is KeyUpEvent) {
      if (event.logicalKey ==
          LogicalKeyboardKey.arrowDown) {
        isSoftDropping = false;
      }
    }

    return KeyEventResult.handled;
  }
  ///GAME STATE
  void togglePause() {
    isPaused = !isPaused;

    if (isPaused) {
      overlays.add('Pause');
    } else {
      overlays.remove('Pause');
    }
  }
  void resetGame() {
    score = 0;
    totalLines = 0;
    level = 1;
    isGameOver = false;

    board = List.generate(
      rows,
          (_) => List.filled(cols, 0),
    );

    currentPiece = createNextPiece(cols);

    overlays.remove('GameOver');
  }

  ///Rotate Block
  void _rotatePiece() {
    final oldShape = currentPiece.shape;
    final rotated = _rotateMatrix(oldShape);

    if (!_isValidPosition(
      rotated,
      currentPiece.x,
      currentPiece.y,
    )) {
      return; // nếu va chạm → không rotate
    }

    currentPiece.shape = rotated;
  }

  List<List<int>> _rotateMatrix(List<List<int>> matrix) {
    final rowsCount = matrix.length;
    final colsCount = matrix[0].length;

    final rotated = List.generate(
      colsCount,
          (_) => List.filled(rowsCount, 0),
    );

    for (int row = 0; row < rowsCount; row++) {
      for (int col = 0; col < colsCount; col++) {
        rotated[col][rowsCount - 1 - row] =
        matrix[row][col];
      }
    }

    return rotated;
  }

  ///SCORE & LEVEL
  void _clearLines() {
    int linesCleared = 0;

    for (int row = rows - 1; row >= 0; row--) {
      if (!board[row].contains(0)) {
        board.removeAt(row);
        board.insert(0, List.filled(cols, 0));
        linesCleared++;
        row++;
      }
    }

    if (linesCleared > 0) {
      totalLines += linesCleared;
      _addScore(linesCleared);
      _checkLevelUp();
    }
  }

  void _addScore(int lines) {
    switch (lines) {
      case 1:
        score += 100;
        break;
      case 2:
        score += 300;
        break;
      case 3:
        score += 500;
        break;
      case 4:
        score += 800; // Tetris
        break;
    }
    notifyListeners();
  }

  void _checkLevelUp() {
    int newLevel = (totalLines ~/ 10) + 1;

    if (newLevel > level) {
      level = newLevel;

      // giảm tốc độ rơi
      normalDropSpeed = (0.5 - (level - 1) * 0.05)
          .clamp(0.1, 0.5);
      notifyListeners();
    }
  }


  bool _isValidPosition(
      List<List<int>> shape,
      int posX,
      int posY,
      ) {
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (shape[row][col] == 1) {
          final newX = posX + col;
          final newY = posY + row;

          // tường trái/phải
          if (newX < 0 || newX >= cols) return false;

          // đáy
          if (newY >= rows) return false;

          // block cố định
          if (newY >= 0 &&
              newY < rows &&
              board[newY][newX] == 1) {
            return false;
          }
        }
      }
    }

    return true;
  }
  ///MOVE BLOCK
  void _hardDrop() {
    while (!_isCollidingDown()) {
      currentPiece.y += 1;
    }

    _lockPiece();
    _spawnNewPiece();
  }

  void _movePiece(int direction) {
    if (_isCollidingSide(direction)) return;

    currentPiece.x += direction;
  }

  bool _isCollidingSide(int direction) {
    final piece = currentPiece;

    for (int row = 0; row < piece.shape.length; row++) {
      for (int col = 0; col < piece.shape[row].length; col++) {
        if (piece.shape[row][col] == 1) {
          final newX = piece.x + col + direction;
          final newY = piece.y + row;

          // 🔹 Va chạm tường trái/phải
          if (newX < 0 || newX >= cols) {
            return true;
          }

          // 🔹 Va chạm block cố định
          if (newY >= 0 &&
              newY < rows &&
              board[newY][newX] == 1) {
            return true;
          }
        }
      }
    }

    return false;
  }


  ///SPAWN PIECE
  void _spawnNewPiece() {
    currentPiece = createNextPiece(cols);
    dropTimer = 0;

    // 🔥 Check nếu spawn đã va chạm
    if (!_isValidPosition(
      currentPiece.shape,
      currentPiece.x,
      currentPiece.y,
    )) {
      isGameOver = true;
      overlays.add('GameOver');
    }
  }

  ///MOVING BLOCK
  void _movePieceDown() {
    if (_isCollidingDown()) {
      _lockPiece();
      return;
    }

    currentPiece.y += 1;
  }

  void _lockPiece() {
    final piece = currentPiece;

    for (int row = 0; row < piece.shape.length; row++) {
      for (int col = 0; col < piece.shape[row].length; col++) {
        if (piece.shape[row][col] == 1) {
          board[piece.y + row][piece.x + col] = 1;
        }
      }
    }
    _clearLines();

    _spawnNewPiece();
  }

  bool _isCollidingDown() {
    final piece = currentPiece;

    for (int row = 0; row < piece.shape.length; row++) {
      for (int col = 0; col < piece.shape[row].length; col++) {
        if (piece.shape[row][col] == 1) {
          final newX = piece.x + col;
          final newY = piece.y + row + 1;

          // 🔹 Va chạm đáy
          if (newY >= rows) {
            return true;
          }

          // 🔹 Va chạm block cố định
          if (newY >= 0 &&
              newY < rows &&
              newX >= 0 &&
              newX < cols &&
              board[newY][newX] == 1) {
            return true;
          }
        }
      }
    }

    return false;
  }


  ///MAKING BOARD
  void _initBoard() {
    board = List.generate(
      rows,
          (_) => List.filled(cols, 0),
    );

  }

  void _caculateBoardSize() {
    blockSize = size.y / 26;
    double boardWidth = cols * blockSize;
    double boardHeight = rows * blockSize;

    boardOffsetX = (size.x - boardWidth) / 2;
    boardOffsetY = (size.y - boardHeight) / 1.3;
  }

  void _createGrid() {
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        add(
          RectangleComponent(
            position: Vector2(
              boardOffsetX + col * blockSize,
              boardOffsetY + row * blockSize,
            ),
            size: Vector2.all(blockSize),
            paint: Paint()
              ..color = AppColors.textSecondary
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          ),
        );
      }
    }
  }
}

