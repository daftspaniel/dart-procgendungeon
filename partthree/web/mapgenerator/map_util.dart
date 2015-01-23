library maputil;
import "map_shapes.dart";
import 'map_entities.dart';

bool isBlockWalkable(int blockType) {
  return (blockType == ROOM || blockType == CORRIDOR);
}

bool isBlockWall(Block b){
  return b.base==WALLN || b.base==WALLS || b.base==WALLE || b.base==WALLW;
}