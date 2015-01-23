import 'dart:html';
import '../mapgenerator/map_entities.dart';
import '../mapgenerator/map_procedural_generated.dart';
import '../rpggame/rpg_player.dart';

ImageElement wall,grass,floor,corner,tree,player;

// Start Load of images and waits for them to complete.
LoadImages(){

  wall = new ImageElement(src: "assets_img/stone.png");
  grass = new ImageElement(src: "assets_img/grass.png");
  floor = new ImageElement(src: "assets_img/floor.png");
  corner = new ImageElement(src: "assets_img/corner.png");
  tree = new ImageElement(src: "assets_img/ftree.png");
  player = new ImageElement(src: "assets_img/player.png");

  return [wall.onLoad.first, floor.onLoad.first, grass.onLoad.first, corner.onLoad.first,  tree.onLoad.first,  player.onLoad.first];

}


void drawMap(CanvasElement ca, PGMap Amap, int tileSize, RPGPlayer p1) {
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

      if (x==p1.x && y==p1.y) ctx.drawImageScaled(player, x * tw, y * tw, tw, tw);
    }
  }
}
