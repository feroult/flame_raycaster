import 'dart:ui';

import 'package:flame/components.dart';

double frac(double v) => v - v.floor();

double invAbs(double v) => (1 / v).abs();

num sq(num v) => v * v;

int col(b, s, p) => (((b * s).floor() & 0xff) << p);

int greyscale(num s, [int b = 255]) =>
    (0xff000000 | col(b, s, 16) | col(b, s, 8) | col(b, s, 0)) & 0xFFFFFFFF;

ilst(d) => d.cast<int>();

dlst(d) => d.cast<double>();

List<Rect> rects(List rects) =>
    rects.map((r) => Rect.fromLTWH(r[0], r[1], r[2], r[3])).toList();

Vector2 vec(v) => Vector2(v[0], v[1]);
