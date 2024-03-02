import 'dart:async';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TowerSelector extends RectangleComponent {
  final width = 300;
  late Images towerImages;
  late List<String> imageNames;
  @override
  FutureOr<void> onLoad() {
    position = Vector2(10, 10);
    for (var i = 0; i < imageNames.length; i++){
      var row = i~/2.ceil() + 1;
      var col = (i - (2 * (row -1))).toInt();
      print("$row $col");
      add(SpriteComponent.fromImage(towerImages.fromCache(imageNames[i]), position: Vector2(0 + col*32 + col * 10, 0 + row*32 + (row>1?10:0)),size: Vector2(32, 32)));
    }
    
  }

  TowerSelector(Images images, List<String> imageN,  Vector2 canvasSize) : super(
    size:  Vector2(300, canvasSize.y - 300),
    position: Vector2(10, 10), //padding from top left
    paint: Paint()..color = Colors.blueGrey,
    anchor: Anchor.center,
    priority: 10,
    ) {
    towerImages = images;
    imageNames = imageN;
  }
  List<Component> buildGrid() {
    return [];
  }
}
