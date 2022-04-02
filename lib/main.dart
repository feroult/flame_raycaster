import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_raycaster/joystick.dart';
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
    add(new RaycasterComponent(
        size: size * 0.8, position: size / 2, anchor: Anchor.center));
    await JoystickBuilder.build(this);
  }
}

class RaycasterComponent extends PositionComponent {
  late XGame game;

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
  Future<void> onLoad() async {
    final level = await loadLevel('data/level2.json');
    game = XGame(
        Size(size[0].floor().toDouble(), size[1].floor().toDouble()), level);
  }

  @override
  @mustCallSuper
  void update(double dt) {}

  @override
  @mustCallSuper
  void onMount() {}

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    game.render(canvas);
  }
}
