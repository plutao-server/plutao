import 'dart:io';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

Future<List<String>> extractTowerImageNames({String towerDirectoryName = "assets/images/towers"}) async{
  var towerDirectory  = Directory(towerDirectoryName);
  List<String> towerImageNames = [];
  try {
      var files = towerDirectory.list();
      await for (final FileSystemEntity file in files){
          if(file is File){
             var fileName = file.path;
            var routes = fileName.split("/");
            routes.removeRange(0,2);
            fileName = routes.join("/");

            print("Extracting ${fileName}");
           
            towerImageNames.add(fileName);
          }
      }
  }catch(e){
    print(e.toString());
  }
  return towerImageNames;
}
Future<Iterable<String>> getTowerImageNameBlocks(List<String> towerImageNames) async{
  return towerImageNames.map((name) => name.split("/").last.split(".").first);
}

Future<bool> loadTowerImages(Images images, List<String> imageNames ) async{
  for (var imageName in imageNames) {
    print("Loading $imageName");
    await images.load(imageName, key: imageName.split("/").last.split(".").first);
   }
   return true;
}
class TowerMapBounds {
  late Vector2 topLeft;
  late Vector2 bottomRight;
  TowerMapBounds(this.topLeft, this.bottomRight);
  TowerMapBounds.relativeToCamera(Vector2 absoluteTopLeft, Vector2 mapSize, Vector2 cameraPosition ){
    topLeft = absoluteTopLeft - cameraPosition;
    bottomRight = topLeft + mapSize;
  }
  bool isContained(Vector2 coordinate){

    //return !(coordinate.x < topLeft.x || coordinate.y < topLeft.y || coordinate.x > topLeft.x || coordinate.y > topLeft.y);
    //invert using demorgan's law
    //this aborts earlier than the !(...) expression because of the &&
    return (coordinate.x > topLeft.x && coordinate.y > topLeft.y && coordinate.x < bottomRight.x && coordinate.y < bottomRight.y);
  }
}
 
Vector2 getCoordsRelToCenter(Vector2 coordsFromTL, Vector2 canvasSize){
  return coordsFromTL - (canvasSize)/2;
}
bool isTileEmpty(RenderableTiledMap tileMap, Vector2 coordinates){
  return tileMap
                .getTileData(layerId: 1, x: coordinates.x.toInt(), y: coordinates.y.toInt())!
                .tile ==
            0 &&
        tileMap
                .getTileData(layerId: 0, x: coordinates.x.toInt(), y: coordinates.y.toInt())!
                .tile ==
            162;
}