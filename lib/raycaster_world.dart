import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import 'level.dart';
import 'raycaster.dart';
import 'utils.dart';

abstract class RaycasterController {
  bool moveForward();

  bool moveBackward();

  bool moveLeft();

  bool moveRight();

  bool rotateLeft();

  bool rotateRight();
}

class RaycasterWorld {
  final Raycaster _rc;
  final Level _lvl;
  final _rotMat = Matrix2.identity(),
      _moveSpeed = 3.0,
      _rotSpeed = 1.7,
      _wallPadding = 0.2;

  double _bobTime = 0.0;
  double _bobFreq = 10; // Frequency
  double _bobAmp = 2; // Amplitude

  RaycasterWorld(double width, double height, this._lvl)
      : _rc = Raycaster(Size(width, height), _lvl);

  void update(double t, RaycasterController controller) {
    var move = _moveSpeed * t,
        rot = _rotSpeed * t,
        dir = _rc.dir,
        pos = _rc.pos,
        plane = _rc.plane;

    var moveVec = Vector2.zero();

    if (controller.moveForward() || controller.moveBackward()) {
      moveVec.x += dir.x * move * (controller.moveForward() ? 1 : -1);
      moveVec.y += dir.y * move * (controller.moveForward() ? 1 : -1);
    }

    if (controller.moveLeft() || controller.moveRight()) {
      moveVec.x += dir.y * move * (controller.moveLeft() ? -1 : 1);
      moveVec.y += -dir.x * move * (controller.moveLeft() ? -1 : 1);
    }

    if (controller.moveForward() ||
        controller.moveBackward() ||
        controller.moveLeft() ||
        controller.moveRight()) {
      _bobTime += t * _bobFreq;
      // if (_bob <= -1 || _bob >= 1) _bobFreq *= -1;
      _translate(_lvl, pos, moveVec, _wallPadding);
    }

    if (controller.rotateLeft() || controller.rotateRight()) {
      _rotMat.setRotation(rot * (controller.rotateLeft() ? 1 : -1));
      _rotMat.transform(dir);
      _rotMat.transform(plane);
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(0, sin((pi / 2) * _bobTime) * _bobAmp);
    _rc.render(canvas);
    canvas.restore();
  }

  void _translate(Level l, Vector2 p, Vector2 d, double w) {
    // Forecast if pos will hit a wall and then translate if it doesn't
    // aka Collision detection
    if (l.get(p.x + d.x, p.y) == 0) p.x += d.x;
    if (l.get(p.x, p.y + d.y) == 0) p.y += d.y;

    // Get the fractional part of the position coordinates
    final fX = frac(p.x);
    final fY = frac(p.y);

    // Add some padding between the camera and the walls
    if (d.x < 0) {
      // Moving left
      if (l.get(p.x - 1, p.y) > 0 && fX < w) p.x += w - fX;
    } else {
      // Moving right
      if (l.get(p.x + 1, p.y) > 0 && fX > 1 - w) p.x -= fX - (1 - w);
    }
    if (d.y < 0) {
      // Moving down
      if (l.get(p.x, p.y - 1) > 0 && fY < w) p.y += w - fY;
    } else {
      // Moving up
      if (l.get(p.x, p.y + 1) > 0 && fY > 1 - w) p.y -= fY - (1 - w);
    }
  }
}
