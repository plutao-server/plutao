import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class TowerSelector extends RectangleComponent  with TapCallbacks{
  final width = 300;
  late Images towerImages;
  late List<String> imageNames;
  late void Function(int) changeCallback;
  @override
  void onTapUp(TapUpEvent event) {
    
  }
  @override
  FutureOr<void> onLoad() {
    position = Vector2(10, 10);
    for (var i = 0; i < imageNames.length; i++){
      var row = i~/2.ceil() + 1;
      var col = (i - (2 * (row -1))).toInt();
      print("$row $col");
      var towerSprite = SpriteComponent.fromImage(towerImages.fromCache(imageNames[i]));
      var towerTileMap = {'tower': 882,  'recycle': 890, 'power': 886};
      add(AdvancedButtonComponent(defaultSkin: towerSprite, hoverSkin: SpriteComponent.fromImage(towerImages.fromCache('placeable')) , position: Vector2(0 + col*32 + col * 10 + 32, 32 + 0 + (row-1)*32 + (row>1?10:0)),size: Vector2(32, 32), onPressed: () =>{changeCallback(towerTileMap[imageNames[i]]!)}));
      //add(SpriteButtonComponent(button: towerSprite,  position: Vector2(0 + col*32 + col * 10, 0 + row*32 + (row>1?10:0)),size: Vector2(32, 32)));
      // add(SpriteComponent.fromImage(towerImages.fromCache(imageNames[i]), position: Vector2(0 + col*32 + col * 10, 0 + row*32 + (row>1?10:0)),size: Vector2(32, 32)));
    }
    
  }

  TowerSelector(Images images, List<String> imageN,  Vector2 canvasSize, void Function(int) callback) : super(
    size:  Vector2(300, canvasSize.y - 300),
    position: Vector2(10, 10), //padding from top left
    paint: Paint()..color = Colors.blueGrey,
    anchor: Anchor.center,
    priority: 10,
    ) {
    towerImages = images;
    imageNames = imageN;
    changeCallback =  callback;
  }
  List<Component> buildGrid() {
    return [];
  }
  
}
