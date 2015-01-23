// Copyright (c) 2015, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'canvasview/map_render.dart';
import 'mapgenerator/map_procedural_generated.dart';
import 'rpggame/rpg_player.dart';
import 'rpggame/rpg_builder.dart';

CanvasRenderingContext2D ctx2d;
InputElement mapHeightRange;
InputElement mapWidthRange;
PGMap mymap;
RPGPlayer p1;
var qS = querySelector;

InputElement refreshButton;

InputElement roomCountRange;
InputElement roomheightRange;

InputElement roomwidthRange;
CanvasElement visualMap;
int zoomLevel;

InputElement zoomRange;

gameLoop(num delta) {

  if (mymap != null && p1 != null) {
    drawMap(visualMap, mymap, zoomLevel, p1);
  }
  window.animationFrame.then(gameLoop);

}

void initGame() {

  int mapwidth = mapWidthRange.valueAsNumber.toInt();
  int mapheight = mapHeightRange.valueAsNumber.toInt();
  int roomwidth = roomwidthRange.valueAsNumber.toInt();
  int roomheight = roomheightRange.valueAsNumber.toInt();
  int roomcount = roomCountRange.valueAsNumber.toInt();
  zoomLevel = zoomRange.valueAsNumber.toInt() * 8;

  var game = buildMap(mapwidth, mapheight, roomwidth, roomheight, roomcount);
  mymap = game[0];
  p1 = game[1];

  window.animationFrame.then(gameLoop);
}

void main() {

  mapWidthRange = qS('#MapWidth')..onChange.listen(remakeMap);
  mapHeightRange = qS('#MapHeight')..onChange.listen(remakeMap);

  roomwidthRange = qS('#RoomWidth')..onChange.listen(remakeMap);
  roomheightRange = qS('#RoomHeight')..onChange.listen(remakeMap);

  roomCountRange = qS('#RoomCount')..onClick.listen(remakeMap);
  zoomRange = qS('#ZoomLevel')..onClick.listen(remakeMap);

  refreshButton = qS('#RefreshButton')..onClick.listen(remakeMap);

  visualMap = querySelector('#surface');

  Future.wait(LoadImages()).then((_) => initGame());

  window.onKeyDown.listen((KeyboardEvent e) {

    if (e.keyCode == 38) p1.moveU();

    else if (e.keyCode == 40) p1.moveD();

    else if (e.keyCode == 39) p1.moveR();

    else if (e.keyCode == 37) p1.moveL();

  });

  window.animationFrame.then(gameLoop);
}

void remakeMap(e) {
  initGame();
}
