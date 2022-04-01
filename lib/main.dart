import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_raycaster/joystick.dart';
import 'package:flame_raycaster/level.dart';
import 'package:flame_raycaster/utils.dart';
import 'package:flame_raycaster/xgame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'buttons.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.setLandscapeLeftOnly();
  final game = RaycasterExempleGame();
  runApp(GameWidget(game: game));
}

class RaycasterExempleGame extends FlameGame with HasDraggables, HasTappables {
  @override
  Future<void> onLoad() async {
    add(new RaycasterComponent());
    await JoystickBuilder.build(this);
  }
}

class RaycasterGame extends FlameGame {
  final viewSize = Size(640, 360);
  late Rect bounds;

  final deviceTransform = Float64List(16);

  late Offset offset;

  late Level level;
  late XGame game;

  RaycasterGame() {
    bounds = Offset.zero & viewSize;
  }

  handleMetricsChanged() async {
    final size = window.physicalSize;
    final pixelRatio = size.shortestSide / viewSize.shortestSide;

    deviceTransform
      ..[0] = pixelRatio
      ..[5] = pixelRatio
      ..[10] = 1
      ..[15] = 1;

    offset = (size / pixelRatio - viewSize as Offset) * 0.5;
  }

  @override
  Future<void> onLoad() async {
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
    super.update(dt);
    game.update(dt, (int i) => false);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.clipRect(bounds);

    game.render(canvas);
    canvas.restore();

    canvas.transform(deviceTransform);
  }
}

class RaycasterComponent extends PositionComponent {
  RaycasterComponent({
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );


  @override
  @mustCallSuper
  void update(double dt) {}

  @override
  @mustCallSuper
  void onMount() {}

  @mustCallSuper
  @override
  void render(Canvas canvas) {}
}
