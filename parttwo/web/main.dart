// Copyright (c) 2015, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'mapgenerator/procedural_generated_map.dart';
import 'canvasview/render.dart';
import 'rpggame/rpg.dart';

InputElement mapWidthRange;
InputElement mapHeightRange;
InputElement roomwidthRange;
InputElement roomheightRange;
InputElement roomCountRange;
InputElement zoomRange;

InputElement refreshButton;

CanvasElement visualMap;
CanvasRenderingContext2D ctx2d;

void main() {

  mapWidthRange = querySelector('#MapWidth')..onChange.listen(remakeMap);
  mapHeightRange = querySelector('#MapHeight')..onChange.listen(remakeMap);

  roomwidthRange = querySelector('#RoomWidth')..onChange.listen(remakeMap);
  roomheightRange = querySelector('#RoomHeight')..onChange.listen(remakeMap);

  roomCountRange = querySelector('#RoomCount')..onClick.listen(remakeMap);
  zoomRange = querySelector('#ZoomLevel')..onClick.listen(remakeMap);

  refreshButton = querySelector('#RefreshButton')..onClick.listen(remakeMap);

  Future.wait(LoadImages()).then((_) => makeMap());

}


void makeMap() {

  int mapwidth = mapWidthRange.valueAsNumber.toInt();
  int mapheight = mapHeightRange.valueAsNumber.toInt();
  int roomwidth = roomwidthRange.valueAsNumber.toInt();
  int roomheight = roomheightRange.valueAsNumber.toInt();
  int roomcount = roomCountRange.valueAsNumber.toInt();
  int zoomrange = zoomRange.valueAsNumber.toInt() * 8;

  PGMap mymap = buildMap(mapwidth, mapheight, roomwidth, roomheight, roomcount);

  visualMap = querySelector('#surface');

  drawMap(visualMap, mymap, zoomrange);
}

void remakeMap(e) {makeMap();}
