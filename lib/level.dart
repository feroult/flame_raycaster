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
  // final List<int> ceil, floor;

  final List<int> ceilFloorGradientColors;
  final List<double> ceilFloorGradientColorStops;

  Level(
    this._map,
    this.mapSize,
    this.atlas,
    this.atlasSize,
    this.pos,
    this.dir,
    this.ceilFloorGradientColors,
    this.ceilFloorGradientColorStops,
  );

  // Convert coordinates to map index (but Y is flipped)
  int get(num x, num y) =>
      _map[(mapSize - y.floor() - 1) * mapSize + x.floor()];
}

class LevelBuilder {
  List<int> _map;
  int _mapSize;
  Image _atlas;
  int _atlasSize;
  var _position = Vector2(0.0, 0.0);
  var _direction = Vector2(0.0, 0.0);
  var _ceilFloorGradientColors = [
    0xFF83769C,
    0xFF83769C,
    0xFF000000,
    0xFF000000,
    0xFFFFCCAA,
    0xFFFFCCAA
  ];
  List<double> _ceilFloorGradientColorStops = [0, 0.35, 0.45, 0.55, 0.65, 1];

  void position(double x, double y) {
    this._position = Vector2(x, y);
  }

  void direction(double x, double y) {
    this._direction = Vector2(x, y);
  }

  void ceilFloorGradient(List<int> colors, [List<double>? colorStops]) {
    this._ceilFloorGradientColors = colors;
    if (colorStops != null) {
      this._ceilFloorGradientColorStops = colorStops;
    }
  }

  LevelBuilder(this._map, this._mapSize, this._atlas, this._atlasSize);

  static Future<LevelBuilder> fromTile(String key) async {
    final tmx = await loadTile(key);
    final map = (tmx.layers[0] as TileLayer).data!;
    final atlas = await loadImage('img/walls.png');
    return LevelBuilder(map, tmx.width, atlas, tmx.tilesets[0].columns!);
  }

  Level build() {
    return Level(_map, _mapSize, _atlas, _atlasSize, _position, _direction,
        _ceilFloorGradientColors, _ceilFloorGradientColorStops);
  }

  static Future<TiledMap> loadTile(String key) async {
    final contents = await Flame.bundle.loadString(key);
    final tmx = TileMapParser.parseTmx(contents);
    return tmx;
  }
}
