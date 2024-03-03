import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:plutao/helpers/util.dart';

class PlutaoWorld extends World with DragCallbacks, TapCallbacks {
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
  
    tiledMap = await TiledComponent.load("map.tmx", Vector2.all(32.0));
    tiledMap!.anchor = Anchor.center;

    CameraComponent.currentCamera?.moveTo(camPos);
    await add(tiledMap!);
  }

  @override
  void render(Canvas canvas) {
    CameraComponent.currentCamera?.moveTo(camPos);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    camPos -= event.localDelta;
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (tiledMap == null) return;

    final mp = getCoordsRelToCenter(event.devicePosition, canvasSize);
    final towerMapBounds = TowerMapBounds.relativeToCamera(
        tiledMap!.topLeftPosition, tiledMap!.scaledSize, camPos);

    if (!towerMapBounds.isContained(mp)) return;
    final tsp = (mp + camPos + tiledMap!.scaledSize / 2) / 32;

    if (isTileEmpty(tiledMap!.tileMap, tsp)) {
      tiledMap!.tileMap.setTileData(
          layerId: 1,
          x: tsp.x.toInt(),
          y: tsp.y.toInt(),
          gid: currrentlySelectedTower);
    }
  }

  void onMouseMove(PointerHoverInfo info) {
    if (tiledMap == null) return;

    final mp = getCoordsRelToCenter(info.eventPosition.widget, canvasSize);
    final towerMapBounds = TowerMapBounds.relativeToCamera(
        tiledMap!.topLeftPosition, tiledMap!.scaledSize, camPos);

    if (!towerMapBounds.isContained(mp)) return;
    final tsp = (mp + camPos + tiledMap!.scaledSize / 2) / 32;

    if (prevMousePosX != null || prevMousePosY != null) {
      if (tsp.x.toInt() != prevMousePosX! || tsp.y.toInt() != prevMousePosY!) {
        tiledMap!.tileMap.setTileData(
            layerId: 2, x: prevMousePosX!, y: prevMousePosY!, gid: emptyId);
      }
    }
    prevMousePosX = tsp.x.toInt();
    prevMousePosY = tsp.y.toInt();
    if (!isTileEmpty(tiledMap!.tileMap, tsp)) {
      print("not 0");
      tiledMap!.tileMap.setTileData(
          layerId: 2,
          x: prevMousePosX!,
          y: prevMousePosY!,
          gid: unplaceableId); //set to unplaceable
      return;
    }
    tiledMap!.tileMap.setTileData(
        layerId: 2, x: prevMousePosX!, y: prevMousePosY!, gid: placeableId);
  }

  void selectedTowerChange(Gid selectedTower) {
    currrentlySelectedTower = selectedTower;
  }
}