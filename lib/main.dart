import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flame/game.dart';
import 'package:flame_raycaster/level.dart';
import 'package:flame_raycaster/utils.dart';
import 'package:flame_raycaster/xgame.dart';
import 'package:flutter/widgets.dart';

import 'buttons.dart';

void main() {
  final game = RaycasterGame();
  runApp(GameWidget(game: game));
}

class RaycasterGame extends FlameGame {
  final viewSize = Size(640, 360);
  late Rect bounds;

  final deviceTransform = Float64List(16);
  late Offset offset;
  late Buttons btns;
  late ui.Image btnAtlas;

  late Level level;
  late XGame game;
  final zero = Duration.zero;
  var prev = Duration.zero;

  RaycasterGame() {
    bounds = Offset.zero & viewSize;
  }

  handleMetricsChanged() async {
    final size = window.physicalSize,
        pixelRatio = size.shortestSide / viewSize.shortestSide;

    deviceTransform
      ..[0] = pixelRatio
      ..[5] = pixelRatio
      ..[10] = 1
      ..[15] = 1;

    offset = (size / pixelRatio - viewSize as Offset) * 0.5;

    btns = await loadButtons(
      'data/buttons.json',
      pixelRatio,
      1 / pixelRatio * window.devicePixelRatio,
      Offset.zero & size / pixelRatio,
      this.btnAtlas,
    );
  }

  @override
  Future<void> onLoad() async {
    btnAtlas = await loadImage('img/gui.png');
    level = await loadLevel('data/level2.json');
    game = XGame(this.viewSize, level);
    await handleMetricsChanged();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    handleMetricsChanged();
  }

  @override
  void update(double dt) {
    game.update(dt, btns.pressed);
  }

  @override
  void render(Canvas canvas) {
    canvas.translate(offset.dx, offset.dy);
    canvas.clipRect(bounds);
    game.render(canvas);
    btns.render(canvas);
  }
}
