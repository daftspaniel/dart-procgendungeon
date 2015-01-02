library shapes;
import "dungeondata.dart";

// Block is the smallest unit of a map.
class block {
  int base = VOID;
  block(this.base);
}

// Point - cell on the map.
class point {
  int x = 0;
  int y = 0;
  point(this.x, this.y) {}
}


// Rectangle - defines a rectangular area on the map.
class rectangle {

  int x = 0;
  int y = 0;
  int width = 0;
  int height = 0;
  int x2 = 0;
  int y2 = 0;

  rectangle(this.x, this.y, this.width, this.height) {update2ndPoints();}

  point getMidPoint() => (new point(x + (width / 2).round(), y + (height / 2).round()));

  void update2ndPoints() {
    x2 = x + width;
    y2 = y + height;
  }
}
