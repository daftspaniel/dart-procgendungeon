import 'dart:html';
import '../mapgenerator/map_entities.dart';
import '../mapgenerator/procedural_generated_map.dart';

ImageElement wall,grass,floor,corner,tree;

// Start Load of images and waits for them to complete.
LoadImages(){

  wall = new ImageElement(src: "img/stone.png");
  grass = new ImageElement(src: "img/grass.png");
  floor = new ImageElement(src: "img/floor.png");
  corner = new ImageElement(src: "img/corner.png");
  tree = new ImageElement(src: "img/ftree.png");

  return [wall.onLoad.first, floor.onLoad.first, grass.onLoad.first, corner.onLoad.first,  tree.onLoad.first];

}


void drawMap(CanvasElement ca, PGMap Amap, int tileSize) {
  int width = Amap.Width;
  int height = Amap.Height;
  int tw = tileSize;
  ca.width = width * tw;
  ca.height = height * tw;

  CanvasRenderingContext2D ctx = ca.getContext("2d");
  ctx.imageSmoothingEnabled = false;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int c = Amap.getBlock(x, y).base;
      if (c == WALLN || c == WALLS || c == WALLE || c == WALLW) {
        ctx.drawImageScaled(wall, x * tw, y * tw, tw, tw);
      } else if (c == WALLCORNER) {
        ctx.drawImageScaled(corner, x * tw, y * tw, tw, tw);
      } else if (c == TREE) {
        ctx.drawImageScaled(grass, x * tw, y * tw, tw, tw);
        ctx.drawImageScaled(tree, x * tw, (y * tw)-4, tw, tw);
      } else if (c == ROOM || c == CORRIDOR) {
        ctx.drawImageScaled(floor, x * tw, y * tw, tw, tw);
      } else {
        ctx.drawImageScaled(grass, x * tw, y * tw, tw, tw);
      }
    }
  }
}
