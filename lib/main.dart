import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Player extends PositionComponent{
  static final _paint = Paint()..color = Colors.white;
  
  @override
  void render(Canvas canvas){
    canvas.drawRect(size.toRect(), _paint);
  }
}

class PlutaoGame extends FlameGame {
  @override
  Future<void> onLoad() async{
    await super.onLoad();
    add(
      Player()
      ..position = size/2
      ..width = 50
      ..height = 100
      ..anchor = Anchor.center
    );
  }
}

void main(){
  final game = FlameGame();
  runApp(GameWidget(game: PlutaoGame()));
}