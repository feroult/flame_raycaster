import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_raycaster/utils.dart';
import 'package:flame_raycaster/xgame.dart';
import 'package:flutter/material.dart';

class CustomRaycasterController extends RaycasterController {
  JoystickComponent joystick;

  CustomRaycasterController(this.joystick);

  @override
  bool moveForward() {
    return [
      JoystickDirection.up,
      JoystickDirection.upLeft,
      JoystickDirection.upRight
    ].contains(joystick.direction);
  }

  @override
  bool moveBackward() {
    return [
      JoystickDirection.down,
      JoystickDirection.downLeft,
      JoystickDirection.downRight
    ].contains(joystick.direction);
  }

  @override
  bool moveRight() {
    return [
      JoystickDirection.right,
      JoystickDirection.upRight,
      JoystickDirection.downRight
    ].contains(joystick.direction);
  }

  @override
  bool moveLeft() {
    return [
      JoystickDirection.left,
      JoystickDirection.upLeft,
      JoystickDirection.downLeft
    ].contains(joystick.direction);
  }

  @override
  bool rotateRight() {
    return false;
  }

  @override
  bool rotateLeft() {
    return false;
  }
}

class JoystickController {
  List<Component> components;
  RaycasterController controller;

  JoystickController(this.components, this.controller);

  static build() async {
    final image = await loadImage('img/joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    final joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
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
        right: 40,
        bottom: 60,
      ),
      onPressed: () => print('flip X'),
    );

    // A button with margin from the edge of the viewport that flips the
    // rendering of the player on the Y-axis.
    final flopButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(2),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(5),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
        right: 120,
        bottom: 60,
      ),
      onPressed: () => print('flip Y'),
    );

    return JoystickController([joystick, flipButton, flopButton],
        CustomRaycasterController(joystick));
  }
}
