import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorldSprite extends SpriteComponent {}

class PlutaoWorld extends World with DragCallbacks {
  bool _isDragged = false;
  Vector2 camPos = Vector2(0.0, 0.0);
  TiledComponent? tiledMap;
  late Vector2 canvasSize;
  Vector2? prevMousePositionTiledMap;
  Gid placeableId = Gid.fromInt(881);
  Gid emptyId = Gid.fromInt(0);
  Gid? unplaceableId;

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

  void onMouseMove(PointerHoverInfo info) {
    if (tiledMap != null) {
      // var data = tiledMap.tileMap.getTileData(layerId: 1, x: info.eventPosition.global.x.toInt(), y: info.eventPosition.global.y.toInt());
      // var data =tiledMap.tileMap.getTileData(layerId: 1, x: 10, y: 0);
      // var objectLayer = tiledMap.tileMap.getLayer<TileLayer>("Object Layer");
      // print(info.eventPosition.widget.x.toInt());
      // print(info.eventPosition.widget.y.toInt());
      //  print(data?.tile);

      //print(tiledMap.topLeftPosition + camPos);
      
      final tlp =tiledMap!.topLeftPosition -camPos;
      final mp = Vector2(info.eventPosition.widget.x - canvasSize.x / 2,
          (info.eventPosition.widget.y - canvasSize.y / 2));
      final brp = tlp + tiledMap!.scaledSize; //bottom right of the map

      if (mp.x < tlp.x || mp.y < tlp.y || mp.x > brp.x || mp.y > brp.y) {
        print("Out of map");
      } else {
        final tsp = (mp + camPos + tiledMap!.scaledSize/2)/32;
        print(tsp);
        
        if (prevMousePositionTiledMap != null) {
          tiledMap!.tileMap.setTileData(
              layerId: 1,
              x: prevMousePositionTiledMap!.x.toInt(),
              y: prevMousePositionTiledMap!.y.toInt(),
              gid: emptyId);
        }
        tiledMap!.tileMap.setTileData(
            layerId: 1, x: tsp.x.toInt(), y: tsp.y.toInt(), gid: placeableId);
        prevMousePositionTiledMap = tsp;
      }
    }
  }

  Vector2 tilePostoMouse(Vector2 tp) {
    //based on number of tiles and tile size
    tp = tp - canvasSize / 2;
    return tp;
  }
}

class PlutaoGame extends FlameGame<PlutaoWorld>
    with SingleGameInstance, MouseMovementDetector {
  late final SpriteComponent test_obj;

  PlutaoGame(PlutaoWorld world) : super(world: world);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.load('stardew-valley-test.jpg');
    camera.viewfinder.anchor = Anchor.center;
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
