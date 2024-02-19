import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorldSprite extends SpriteComponent{
  
  
  
  
}

class PlutaoWorld extends World with DragCallbacks{
  bool _isDragged = false;
  Vector2 camPos = Vector2(0.0, 0.0);
  
  @override
  Future<void> onLoad() async{
    final bgSprite = SpriteComponent(size: Vector2.all(1024.0) , sprite: await Sprite.load("stardew-valley-test.jpg"), anchor: Anchor.center);
     CameraComponent.currentCamera?.moveTo(camPos);
    await add(bgSprite);
  }
  @override
  void render(Canvas canvas) {
    // TODO: implement render
    CameraComponent.currentCamera?.moveTo(camPos);
  }
  @override
  void onDragStart(DragStartEvent event){
    _isDragged = true;
  }
  @override
  void onDragEnd(DragEndEvent event) => _isDragged = false;
  @override void onDragUpdate(DragUpdateEvent event) {
    // TODO: implement onDragUpdate
    camPos -= event.localDelta;
  }
  
}

class PlutaoGame extends FlameGame<PlutaoWorld> with SingleGameInstance {
  late final SpriteComponent test_obj;
  
  PlutaoGame(PlutaoWorld world): super(world: world);
  
  @override
  Future<void> onLoad() async{
    await super.onLoad();
    await images.load('stardew-valley-test.jpg');
    camera.viewfinder.anchor = Anchor.center;
     
    
  }
}

void main(){
  final mGame = PlutaoGame( PlutaoWorld());
  runApp(GameWidget(game: mGame));
}