import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_flame/utils/colors.dart';
import 'package:tetris_flame/utils/fonts.dart';
import 'package:tetris_flame/widgets/app_title.dart';
import 'package:tetris_flame/widgets/custom_page.dart';
import 'package:flame/game.dart';

import '../../game/tetris.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<StatefulWidget> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  final TetrisGame _game = TetrisGame();

  // ── Gesture tracking ──────────────────────────────────────────────────────
  Offset? _pointerDown;
  DateTime? _pointerDownTime;
  bool _gestureResolved = false;
  _GestureType _activeGesture = _GestureType.none;

  Timer? _holdTimer;
  Timer? _horizontalTimer;
  Timer? _dasTimer;

  /// Ngưỡng pixel để bắt đầu nhận ra gesture (tránh nhầm tap)
  static const double _swipeThreshold = 8.0;

  /// px/ms — trên ngưỡng này = vuốt nhanh (1 ô), dưới = kéo (liên tục)
  static const double _fastSwipeSpeed = 1.2;

  /// Thời gian giữ ngón tay yên trước khi kích hoạt soft drop
  static const int _holdDelayMs = 180;

  /// DAS delay (ms) trước khi lặp ngang
  static const int _dasDelayMs = 120;

  /// Tốc độ lặp ngang (ms/ô)
  static const int _repeatIntervalMs = 65;
  // ──────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _cancelAllTimers();
    super.dispose();
  }

  void _cancelAllTimers() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _horizontalTimer?.cancel();
    _horizontalTimer = null;
    _dasTimer?.cancel();
    _dasTimer = null;
  }

  // ── Pointer handlers ──────────────────────────────────────────────────────

  void _onPointerDown(PointerDownEvent event) {
    _pointerDown = event.position;
    _pointerDownTime = DateTime.now();
    _gestureResolved = false;
    _activeGesture = _GestureType.none;

    // Đếm giờ: nếu ngón tay giữ yên → soft drop
    _holdTimer = Timer(
      const Duration(milliseconds: _holdDelayMs),
          () {
        if (!_gestureResolved) {
          _gestureResolved = true;
          _activeGesture = _GestureType.hold;
          _game.startSoftDrop();
        }
      },
    );
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointerDown == null || _gestureResolved) return;

    final delta = event.position - _pointerDown!;
    final dx = delta.dx.abs();
    final dy = delta.dy.abs();

    // Chưa đủ ngưỡng
    if (dx < _swipeThreshold && dy < _swipeThreshold) return;

    // Có chuyển động → huỷ hold timer
    _holdTimer?.cancel();
    _gestureResolved = true;

    if (dy > dx) {
      // ── Dọc ──────────────────────────────────────────────────────────────
      if (delta.dy > 0) {
        _activeGesture = _GestureType.swipeDown;
        if (!_game.isPaused && !_game.isGameOver) {
          _game.hardDropMobile();
        }
      }
      // Vuốt lên: không làm gì
    } else {
      // ── Ngang ─────────────────────────────────────────────────────────────
      final elapsedMs =
      DateTime.now().difference(_pointerDownTime!).inMilliseconds.clamp(1, 99999);
      final speed = dx / elapsedMs; // px/ms
      final direction = delta.dx > 0 ? 1 : -1;

      if (speed >= _fastSwipeSpeed) {
        // Vuốt nhanh → 1 ô
        _activeGesture = _GestureType.swipeHorizontal;
        if (!_game.isPaused && !_game.isGameOver) {
          _moveHorizontalOnce(direction);
        }
      } else {
        // Kéo chậm → liên tục
        _activeGesture = _GestureType.dragHorizontal;
        _startContinuousHorizontal(direction);
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _holdTimer?.cancel();

    if (_activeGesture == _GestureType.hold) {
      _game.stopSoftDrop();
    }

    // Không có gesture nào → là tap → xoay
    if (!_gestureResolved) {
      if (!_game.isPaused && !_game.isGameOver) {
        _game.rotateMobile();
      }
    }

    _cancelAllTimers();
    _activeGesture = _GestureType.none;
    _pointerDown = null;
    _pointerDownTime = null;
    _gestureResolved = false;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (_activeGesture == _GestureType.hold) {
      _game.stopSoftDrop();
    }
    _cancelAllTimers();
    _activeGesture = _GestureType.none;
    _pointerDown = null;
    _pointerDownTime = null;
    _gestureResolved = false;
  }

  // ── Horizontal helpers ────────────────────────────────────────────────────

  void _moveHorizontalOnce(int direction) {
    if (direction > 0) {
      _game.moveRightMobile();
    } else {
      _game.moveLeftMobile();
    }
  }

  void _startContinuousHorizontal(int direction) {
    _dasTimer?.cancel();
    _horizontalTimer?.cancel();

    // Bước đầu ngay lập tức
    _moveHorizontalOnce(direction);

    // Sau DAS delay → lặp liên tục
    _dasTimer = Timer(
      const Duration(milliseconds: _dasDelayMs),
          () {
        _horizontalTimer = Timer.periodic(
          const Duration(milliseconds: _repeatIntervalMs),
              (_) {
            if (_game.isPaused || _game.isGameOver) return;
            _moveHorizontalOnce(direction);
          },
        );
      },
    );
  }

  // ── HUD ───────────────────────────────────────────────────────────────────

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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      widget: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gameBg,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerDown: _onPointerDown,
                    onPointerMove: _onPointerMove,
                    onPointerUp: _onPointerUp,
                    onPointerCancel: _onPointerCancel,
                    child: GameWidget(
                      game: _game,
                      overlayBuilderMap: {
                        'HUD': (context, game) =>
                            _buildHUD(game as TetrisGame),
                        'Pause': (context, game) => Center(
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
                        ),
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
                                      onPressed: () => g.resetGame(),
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
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: AppTitle(style: AppFonts.pixeloidSemiBold16),
                ),
              ],
            ),

            // Nút Pause — nằm ngoài Listener nên không bị ảnh hưởng gesture
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => _game.togglePause(),
                child: Container(
                  margin: const EdgeInsets.only(right: 16, top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.boardBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.6),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Icon(
                    _game.isPaused ? Icons.play_arrow : Icons.pause,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _GestureType { none, hold, swipeHorizontal, dragHorizontal, swipeDown }