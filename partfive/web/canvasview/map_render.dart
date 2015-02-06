import 'dart:html';
import 'dart:async';

import '../mapgenerator/map_entities.dart';
import '../mapgenerator/map_procedural_generated.dart';
import '../rpggame/rpg_player.dart';

ImageElement wall, grass, floor, corner, tree, player, door, shrub;
ImageElement diamond;

AudioElement winsnd;

List<Future> loadAssets(){
  loadAudio();
  return loadImages();
}

// Start Load of images and waits for them to complete.
List<Future> loadImages() {

  wall = new ImageElement(src: "assets_img/stone.png");
  grass = new ImageElement(src: "assets_img/grass.png");
  floor = new ImageElement(src: "assets_img/floor.png");
  corner = new ImageElement(src: "assets_img/corner.png");
  tree = new ImageElement(src: "assets_img/ftree.png");
  player = new ImageElement(src: "assets_img/player.png");
  door = new ImageElement(src: "assets_img/door.png");
  diamond = new ImageElement(src: "assets_img/diamond.png");
  shrub = new ImageElement(src: "assets_img/shrub.png");

  return [wall.onLoad.first, floor.onLoad.first, grass.onLoad.first,
          corner.onLoad.first, tree.onLoad.first, player.onLoad.first,
          diamond.onLoad.first, shrub.onLoad.first];

}

List<Future> loadAudio(){
  winsnd = new AudioElement("assets_snd/coin.mp3");
  winsnd.preload = "auto";
  return [winsnd.onLoad.first];
}

playSnd(){
  winsnd.play();
  winsnd.onEnded.listen(done);
}

done (e){
  winsnd.load();
}

void drawMap(CanvasRenderingContext2D ctx, PGMap Amap, int tileSize, RPGPlayer p1, int viewport) {
  int width = Amap.Width;
  int height = Amap.Height;
  int tw = tileSize;

  int df = (viewport / 2).round();
  int ox = p1.x - df;
  int oy = p1.y - df;
  int dx = 0;
  int dy = 0;
  var img = null;
  int c = 0;
  int v = 0;
  int DX = 0;
  int DY = 0;
  for (int y = oy; y < oy + viewport; y++) {
    for (int x = ox; x < ox + viewport; x++) {

      DX = dx * tw;
      DY = dy * tw;
      var b = Amap.getBlock(x, y);
      if (b != null) {

        c = b.base;
        v = 0;

        if (c == WALLN || c == WALLS || c == WALLE || c == WALLW) {
          img = wall;
        } else if (c == WALLCORNER) {
          img = corner;
        } else if (c == DOOR) {
          img = door;
        } else if (c == TREE) {
          img = tree;
          ctx.drawImageScaled(grass, DX, DY, tw, tw);
          v = (x*y % 9 - 4);
        } else if (c == ROOM || c == CORRIDOR) {
          img = floor;
        } else {
          img = grass;
        }


        ctx.drawImageScaled(img, DX +v, DY + v, tw, tw);

        if (b.items!=null)
        {
          b.items.forEach((item){

            if (item==DIAMOND)
              ctx.drawImageScaled(diamond, DX, DY, tw, tw);
          });
        }

        if (x == p1.x && y == p1.y) ctx.drawImageScaled(player, DX, DY, tw, tw);
      }
      else{
        ctx.drawImageScaled(grass, DX, DY, tw, tw);
        ctx.drawImageScaled(shrub, DX, DY, tw, tw);
      }
      dx += 1;
    }
    dy += 1;
    dx = 0;
  }
}
