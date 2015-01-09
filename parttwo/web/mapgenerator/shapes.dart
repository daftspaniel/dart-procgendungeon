library shapes;

import 'map_entities.dart';

/// Block is the smallest unit of a map.
class Block {
  int base = VOID;
  Block(this.base);
}

/// Point Class.
class Point {
  int x = 0;
  int y = 0;
  Point(this.x, this.y) {}
}


// Rectangle - defines a rectangular area on the map.
class MapRectangle {

  int x = 0;
  int y = 0;
  int width = 0;
  int height = 0;
  int x2 = 0;
  int y2 = 0;

  MapRectangle(this.x, this.y, this.width, this.height) {update2ndPoints();}

  Point getMidPoint() => (new Point(x + (width / 2).round(), y + (height / 2).round()));

  void update2ndPoints() {
    x2 = x + width;
    y2 = y + height;
  }
}
