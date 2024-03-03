
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plutao/tower_selector.dart';

class WorldSprite extends SpriteComponent {}

class PlutaoWorld extends World with DragCallbacks, TapCallbacks {
  bool _isDragged = false;
  Vector2 camPos = Vector2(0.0, 0.0);
  TiledComponent? tiledMap;
  late Vector2 canvasSize;
  //Vector2? prevMousePositionTiledMap;
  int? prevMousePosX, prevMousePosY;
  Gid placeableId = Gid.fromInt(881);
  Gid emptyId = Gid.fromInt(0);
  Gid towerId = Gid.fromInt(884);
  Gid powerId = Gid.fromInt(885);
  Gid recycleId = Gid.fromInt(889);
  Gid currrentlySelectedTower = Gid.fromInt(884);

  Gid unplaceableId = Gid.fromInt(894);

  @override
  Future<void> onLoad() async {
    // final bgSprite = SpriteComponent(
    //     size: Vector2(1280.0, 720.0),
    //     sprite: await Sprite.load("map.png"),
    //     anchor: Anchor.center);
    tiledMap = await TiledComponent.load("map.tmx", Vector2.all(32.0));
    tiledMap!.anchor = Anchor.center;
    var objectLayer = tiledMap!.tileMap.getLayer<TileLayer>("Object Layer");
    CameraComponent.currentCamera?.moveTo(camPos);
    await add(tiledMap!);
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    CameraComponent.currentCamera?.moveTo(camPos);
  }

  @override
  void onDragStart(DragStartEvent event) {
    _isDragged = true;
  }

  @override
  void onDragEnd(DragEndEvent event) => _isDragged = false;
  @override
  void onDragUpdate(DragUpdateEvent event) {
    // TODO: implement onDragUpdate
    camPos -= event.localDelta;
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (tiledMap != null) {
      final tlp = tiledMap!.topLeftPosition - camPos;
      final mp = Vector2(event.devicePosition.x - canvasSize.x / 2,
          (event.devicePosition.y - canvasSize.y / 2));

      final brp = tlp + tiledMap!.scaledSize;
      print(mp);
      if (!(mp.x < tlp.x || mp.y < tlp.y || mp.x > brp.x || mp.y > brp.y)) {
        final tsp = (mp + camPos + tiledMap!.scaledSize / 2) / 32;
        if (tiledMap!.tileMap
                .getTileData(layerId: 1, x: tsp.x.toInt(), y: tsp.y.toInt())!.tile == 0  && tiledMap!.tileMap.getTileData(layerId: 0, x: tsp.x.toInt(), y: tsp.y.toInt())!.tile == 162) {
          tiledMap!.tileMap.setTileData(
              layerId: 1,
              x: tsp.x.toInt(),
              y: tsp.y.toInt(),
              gid: currrentlySelectedTower);
        }
      }
    }
  }

  void onMouseMove(PointerHoverInfo info) {
    if (tiledMap == null) return;
    final tlp = tiledMap!.topLeftPosition - camPos;
    final mp = Vector2(info.eventPosition.widget.x - canvasSize.x / 2,
        (info.eventPosition.widget.y - canvasSize.y / 2));
    final brp = tlp + tiledMap!.scaledSize; //bottom right of the map

    if (!(mp.x < tlp.x || mp.y < tlp.y || mp.x > brp.x || mp.y > brp.y)) {
      final tsp = (mp + camPos + tiledMap!.scaledSize / 2) / 32;

      if (prevMousePosX != null || prevMousePosY != null) {
        if (tsp.x.toInt() / 32 != prevMousePosX! / 32 ||
            tsp.y.toInt() / 32 != prevMousePosY! / 32) {
          tiledMap!.tileMap.setTileData(
              layerId: 2, x: prevMousePosX!, y: prevMousePosY!, gid: emptyId);
        }
      }

      prevMousePosX = tsp.x.toInt();
      prevMousePosY = tsp.y.toInt();
      if (tiledMap!.tileMap
                .getTileData(layerId: 1, x: tsp.x.toInt(), y: tsp.y.toInt())!.tile != 0 || tiledMap!.tileMap.getTileData(layerId: 0, x: tsp.x.toInt(), y: tsp.y.toInt())!.tile != 162){
                  print("not 0");
tiledMap!.tileMap.setTileData(
          layerId: 2, x: prevMousePosX!, y: prevMousePosY!, gid: unplaceableId); //set to unplaceable
                  return;
                }
      tiledMap!.tileMap.setTileData(
          layerId: 2, x: prevMousePosX!, y: prevMousePosY!, gid: placeableId);
    } else {
      print("Out of map");
    }
  }

  Vector2 tilePostoMouse(Vector2 tp) {
    //based on number of tiles and tile size
    tp = tp - canvasSize / 2;
    return tp;
  }

  void selectedTowerChange(Gid selectedTower) {
    print("Changed");
    currrentlySelectedTower = selectedTower;
  }
}

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
    await images.load('stardew-valley-test.jpg');
    await images.load('tower.png', key: 'tower');
    await images.load('recycle.png', key: 'recycle');
    await images.load('power.png', key: 'power');
    await images.load('placeable.png', key: 'placeable');
    camera.viewfinder.anchor = Anchor.center;
    var blocks = ["tower", "recycle", "power"];
    var uniqueList = Set.from(blocks).toList();
    var hudChildren = blocks.map((blockName) => SpriteComponent.fromImage(
        images.fromCache(blockName),
        position: Vector2(32, 32) * (uniqueList.indexOf(blockName) * 1)));
    print(hudChildren);
    camera.viewport.add(PositionComponent(
        position: Vector2(canvasSize.x - 150, canvasSize.y / 2),
        children: [TowerSelector(images, blocks, canvasSize, onChangeSelect)]));
    world.canvasSize = canvasSize;
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    world.onMouseMove(info);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
  }
}

void main() {
  final mGame = PlutaoGame(PlutaoWorld());
  runApp(GameWidget(game: mGame));
}
