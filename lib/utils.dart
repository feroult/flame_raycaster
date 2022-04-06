import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:tiled/tiled.dart';
import 'package:vector_math/vector_math.dart';

import 'level.dart';

double frac(double v) => v - v.floor();

double invAbs(double v) => (1 / v).abs();

num sq(num v) => v * v;

int col(b, s, p) => (((b * s).floor() & 0xff) << p);

int greyscale(num s, [int b = 255]) =>
    (0xff000000 | col(b, s, 16) | col(b, s, 8) | col(b, s, 0)) & 0xFFFFFFFF;

ilst(d) => d.cast<int>();

dlst(d) => d.cast<double>();

Future<Image> loadImage(String key) async {
  final d = await rootBundle.load(key);
  final b = Uint8List.view(d.buffer);
  final c = Completer<Image>();
  decodeImageFromList(b, (i) => c.complete(i));
  return c.future;
}

Future<Level> loadLevel(String key) async {
  final d = jsonDecode(await rootBundle.loadString(key));
  final map = await loadMap();
  return Level(
    // ilst(d['map']),
    map,
    d['mapSize'],
    await loadImage(d['atlas']),
    d['atlasSize'],
    // origin the bottom-left of the map array
    vec(dlst(d['pos'])),
    vec(dlst(d['dir'])),
    ilst(d['ceil']),
    ilst(d['floor']),
  );
}

List<Rect> rects(List rects) =>
    rects.map((r) => Rect.fromLTWH(r[0], r[1], r[2], r[3])).toList();

Vector2 vec(v) => Vector2(v[0], v[1]);

Future<List<int>> loadMap() async {
  final contents = await Flame.bundle.loadString('data/raycaster.tmx');
  final tmx = TileMapParser.parseTmx(contents);
  final map = (tmx.layers[0] as TileLayer).data!;
  return map;
}

