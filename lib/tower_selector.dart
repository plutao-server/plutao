import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class TowerSelector extends RectangleComponent with TapCallbacks {
  final width = 300;
  late Iterable<String> imageNames;
  late void Function(int) changeCallback;
  @override
  void onTapUp(TapUpEvent event) {}
  @override
  FutureOr<void> onLoad() {
    position = Vector2(10, 10);
    for (var i = 0; i < imageNames.length; i++) {
      
      var towerSprite = SpriteComponent.fromImage(
          Flame.images.fromCache(imageNames.elementAt(i)));
      var hoverSprite =
          SpriteComponent.fromImage(Flame.images.fromCache('placeable'));
      var towerTileMap = {
        'tower': 882,
        'recycle': 890,
        'power': 886
      }; //change this later so its not hardcoded
      
      add(AdvancedButtonComponent(
          defaultSkin: towerSprite,
          hoverSkin: hoverSprite,
          position: getGridPosition(i, 32),
          size: Vector2(32, 32),
          onPressed: () =>
              {changeCallback(towerTileMap[imageNames.elementAt(i)]!)}));
    }
  }

  TowerSelector(
      this.imageNames, Vector2 canvasSize, void Function(int) callback)
      : super(
          size: Vector2(300, canvasSize.y - 300),
          position: Vector2(10, 10), //padding from top left
          paint: Paint()..color = Colors.blueGrey,
          anchor: Anchor.center,
          priority: 10,
        ) {
    changeCallback = callback;
  }
  getGridPosition(int itemIndex, int itemSize) {
    var row = itemIndex ~/ 2.ceil() + 1;
    var col = (itemIndex - (2 * (row - 1))).toInt();
    return Vector2(0 + col * itemSize + col * 10 + 32,
        32 + 0 + (row - 1) * itemSize + (row > 1 ? 10 : 0));
  }
}
