import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_raycaster/joystick_controller.dart';
import 'package:flame_raycaster/utils.dart';
import 'package:flame_raycaster/xgame.dart';
import 'package:flutter/widgets.dart';

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
    add(new RaycasterComponent(joystick.controller, size: size));
    addAll(joystick.components);
  }
}

class RaycasterComponent extends PositionComponent {
  RaycasterController controller;
  late XGame game;

  RaycasterComponent(
    this.controller, {
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,g
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
    final level = await loadLevel('data/level.json');
    game = XGame(
        Size(size[0].floor().toDouble(), size[1].floor().toDouble()), level);
  }

  @override
  @mustCallSuper
  void update(double dt) {
    game.update(dt, controller);
  }

  @override
  @mustCallSuper
  void onMount() {}

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    game.render(canvas);
  }
}
