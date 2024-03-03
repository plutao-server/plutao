import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plutao/helpers/util.dart';
import 'package:plutao/tower_selector.dart';
import 'package:plutao/world.dart';


class PlutaoGame extends FlameGame<PlutaoWorld>
    with SingleGameInstance, MouseMovementDetector {
  late final SpriteComponent test_obj;

  PlutaoGame(PlutaoWorld world) : super(world: world);
  void onChangeSelect(int towerGid) {
    world.selectedTowerChange(Gid.fromInt(towerGid));
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    var towerImageNames = await extractTowerImageNames();
    var towerImageNameBlocks = await getTowerImageNameBlocks(towerImageNames);
    await loadTowerImages(images, towerImageNames);
    await images.load('placeable.png', key: 'placeable'); //remove in future

    camera.viewfinder.anchor = Anchor.center;
    camera.viewport.add(PositionComponent(
        position: Vector2(canvasSize.x - 150, canvasSize.y / 2),
        children: [
          TowerSelector(
             towerImageNameBlocks, canvasSize, onChangeSelect)
        ]));
    world.canvasSize = canvasSize;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    world.onMouseMove(info);
  }
}

void main() {
  final mGame = PlutaoGame(PlutaoWorld());
  runApp(GameWidget(game: mGame));
}
