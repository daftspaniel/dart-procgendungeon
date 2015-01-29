library maputil;
import "map_shapes.dart";
import 'map_entities.dart';

bool isBlockWalkable(int blockType) {
  return (blockType == ROOM || blockType == CORRIDOR || blockType == DOOR || blockType == VOID || blockType == TREE );
}

bool isBlockWall(Block b){
  return b.base==WALLN || b.base==WALLS || b.base==WALLE || b.base==WALLW;
}