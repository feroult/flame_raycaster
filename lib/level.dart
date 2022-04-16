import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_raycaster/utils.dart';
import 'package:tiled/tiled.dart';

class Level {
  // The map data
  final List<int> _map;

  // The atlas texture
  final Image atlas;

  // mapSize - The map's width and height (only square maps are supported)
  // atlasSize - The atlas' tile width and height (only square atlases are supported)
  final int mapSize, atlasSize;

  // Camera position
  final Vector2 pos, // Camera position
      dir; // Direction vector
  final List<int> ceil, floor;

  Level(
    this._map,
    this.mapSize,
    this.atlas,
    this.atlasSize,
    this.pos,
    this.dir,
    this.ceil,
    this.floor,
  );

  static Future<Level> fromTile(String key, Vector2 pos, Vector2 dir) async {
    final tmx = await loadTile(key);
    final map = (tmx.layers[0] as TileLayer).data!;
    final atlas = await loadImage('img/walls.png');
    final ceil = [4286805660, 4284438351];
    final floor = [4294954154, 4289417782];
    return Level(map, tmx.width, atlas, 4, pos, dir, ceil, floor);
  }

  // Convert coordinates to map index (but Y is flipped)
  int get(num x, num y) =>
      _map[(mapSize - y.floor() - 1) * mapSize + x.floor()];
}

Future<TiledMap> loadTile(String key) async {
  final contents = await Flame.bundle.loadString(key);
  final tmx = TileMapParser.parseTmx(contents);
  return tmx;
}
