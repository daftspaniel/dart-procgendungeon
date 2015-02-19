// Copyright (c) 2015, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'canvasview/map_render.dart';
import 'mapgenerator/map_procedural_generated.dart';
import 'rpggame/rpg_builder.dart';
import 'rpggame/rpg_character.dart';
import 'dart:js';

var qS = querySelector;

InputElement refreshButton;
CanvasElement visualMap;
CanvasRenderingContext2D ctx;

bool canvasConfigured = false;
int zoomLevel = 32;
int viewport = 19;
JsObject jsproxy = new JsObject(context['crossBrowserFilla']);

PGMap mymap;
RPGCharacter p1;
List<RPGCharacter> ninjas;

gameLoop(num delta) {

  if (mymap != null && p1 != null) {
    if (!canvasConfigured) {
      jsproxy.callMethod('keepThingsBlocky');
      canvasConfigured = true;
    }
    drawMap(ctx, mymap, zoomLevel, p1, viewport, ninjas);
  }
  new Future.delayed(const Duration(milliseconds: 250), () {
    window.requestAnimationFrame(gameLoop);
  });

}

void initGame() {

  int mapwidth = 50;
  int mapheight = 50;
  int roomwidth = 8;
  int roomheight = 8;
  int roomcount = 7 + RND(5);
  int side = viewport * zoomLevel;

  if (visualMap.width != side) visualMap.width = side;

  if (visualMap.height != side) visualMap.height = side;

  //ctx.imageSmoothingEnabled = false;

  var game = buildMap(mapwidth, mapheight, roomwidth, roomheight, roomcount);
  mymap = game[0];
  p1 = game[1];
  ninjas = game[2];

  window.animationFrame.then(gameLoop);
}

void main() {

  refreshButton = qS('#RefreshButton')..onClick.listen(remakeMap);

  visualMap = querySelector('#surface');
  ctx = visualMap.getContext("2d");

  Future.wait(loadAssets()).then((_) => initGame());

  window.onKeyUp.listen((KeyboardEvent e) {

    if (e.keyCode == 38) {
      p1.moveU();
    } else if (e.keyCode == 40) p1.moveD(); else if (e.keyCode == 39) p1.moveR(); else if (e.keyCode == 37) p1.moveL();

    drawMap(ctx, mymap, zoomLevel, p1, viewport, ninjas);
  });

  Timer logup = new Timer.periodic(new Duration(milliseconds: 1000), gameLogicUpdate);
  window.animationFrame.then(gameLoop);

  var jsproxy = new JsObject(context['crossBrowserFilla']);
  jsproxy.callMethod('keepThingsBlocky');
}

void gameLogicUpdate(e) {
  if (mymap != null) mymap.updatePlayer(p1, playSnd);

  ninjas.forEach((n) {
    int m = RND(4);
    if (m == 1) n.moveU();
    if (m == 2) n.moveD();
    if (m == 3) n.moveL();
    if (m == 4) n.moveR();
  });
}
void remakeMap(e) {
  initGame();
}
