import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_raycaster/joystick_controller.dart';
import 'package:flame_raycaster/raycaster_world.dart';
import 'package:flutter/widgets.dart';

import 'level.dart';

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
    final joystick = await JoystickController.build();

    final builder = await LevelBuilder.fromTile('assets/tiles/raycaster.tmx');

    final level = (builder
          ..position(4.0, 4.0)
          ..direction(1.0, 2.0)
          ..ceilFloorGradient([
            0xFF83769C,
            0xFF83769C,
            0xFF000000,
            0xFF000000,
            0xFFFFCCAA,
            0xFFFFCCAA
          ], [
            0,
            0.35,
            0.45,
            0.55,
            0.65,
            1
          ]))
        .build();

    add(new RaycasterComponent(level, joystick.controller, size: size));
    addAll(joystick.components);
  }
}

class RaycasterComponent extends PositionComponent {
  Level level;
  RaycasterController controller;
  late RaycasterWorld world;

  RaycasterComponent(
    this.level,
    this.controller, {
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
  Future<void> onLoad() async {
    var width = size[0].floor().toDouble();
    var height = size[1].floorToDouble().toDouble();
    world = RaycasterWorld(width, height, level);
  }

  @override
  @mustCallSuper
  void update(double dt) {
    world.update(dt, controller);
  }

  @override
  @mustCallSuper
  void onMount() {}

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    world.render(canvas);
  }
}
