// Copyright (c) 2014, Davy Mitchell. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'procedural_generated_map.dart';

InputElement mapWidthRange;
InputElement mapHeightRange;
InputElement roomwidthRange;
InputElement roomheightRange;
InputElement roomCountRange;
InputElement refreshButton;

PreElement visualMap;

void main() {

  mapWidthRange = querySelector('#MapWidth')
      ..onChange.listen(remakeMap);
  mapHeightRange = querySelector('#MapHeight')
      ..onChange.listen(remakeMap);

  roomwidthRange = querySelector('#RoomWidth')
      ..onChange.listen(remakeMap);
  roomheightRange = querySelector('#RoomHeight')
      ..onChange.listen(remakeMap);

  roomCountRange = querySelector('#RoomCount')
      ..onClick.listen(remakeMap);

  refreshButton = querySelector('#RefreshButton')
      ..onClick.listen(remakeMap);

  makeMap();
}

void makeMap() {

  int mapwidth = mapWidthRange.valueAsNumber.toInt();
  int mapheight = mapHeightRange.valueAsNumber.toInt();
  int roomwidth = roomwidthRange.valueAsNumber.toInt();
  int roomheight = roomheightRange.valueAsNumber.toInt();
  int roomcount =  roomCountRange.valueAsNumber.toInt();

  pgmap mymap = new pgmap( mapwidth, mapheight, roomwidth, roomheight);
  mymap.generate();
  mymap.createMap(roomcount);

  visualMap = querySelector('#visualMap');
  visualMap.text = mymap.show();
}

void remakeMap(e){

  makeMap();
}