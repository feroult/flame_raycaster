import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame_raycaster/utils.dart';
import 'package:flutter/material.dart';

class JoystickAdvancedExample extends PositionComponent {
  late final JoystickComponent joystick;

  JoystickAdvancedExample({Vector2? size, Vector2? position})
      : super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    final image = await loadImage('img/joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 0, top: 0),
    );

    final buttonSize = Vector2.all(80);
    // A button with margin from the edge of the viewport that flips the
    // rendering of the player on the X-axis.
    final flipButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(2),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(4),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
        right: 80,
        bottom: 60,
      ),
      onPressed: () => print('flip X'),
    );

    // A button with margin from the edge of the viewport that flips the
    // rendering of the player on the Y-axis.
    final flopButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(3),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(5),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
        right: 160,
        bottom: 60,
      ),
      onPressed: () => print('flip Y'),
    );

    final rng = Random();
    // A button, created from a shape, that adds a rotation effect to the player
    // when it is pressed.
    final shapeButton = HudButtonComponent(
        button: CircleComponent(radius: 35),
        buttonDown: RectangleComponent(
          size: buttonSize,
          paint: BasicPalette.blue.paint(),
        ),
        margin: const EdgeInsets.only(
          right: 85,
          bottom: 150,
        ),
        onPressed: () => print('rotate'));

    add(joystick);
    add(flipButton);
    add(flopButton);
  }
}
