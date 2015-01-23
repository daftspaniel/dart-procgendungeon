library procedural_generated_map;

import 'dart:math';

import 'map_entities.dart';
import 'map_shapes.dart';
import 'map_util.dart';

int RND(int maxv) {
  maxv = max(1, maxv);
  return new Random().nextInt(maxv);
}


class PGMap {

  Map<String, Block> Blocks = new Map<String, Block>();
  List<MapRectangle> Rooms = new List<MapRectangle>();

  int RoomCount = 0;
  int CorrCount = 0;

  int Width = 0;
  int Height = 0;
  int MaxRoomWidth = 5;
  int MaxRoomHeight = 8;

  PGMap(this.Width, this.Height, int RoomWidth, int RoomHeight) {
    MaxRoomWidth = RoomWidth;
    MaxRoomHeight = RoomHeight;

    if (RoomWidth > Width) {
      RoomWidth = Width - 6;
    }
    if (RoomHeight > Height) {
      RoomHeight = Height - 6;
    }
  }
  MapPoint First() => Rooms[0].getMidPoint();

  MapPoint Last() => Rooms[Rooms.length - 1].getMidPoint();

  void addCorridor(int x, int y, int d, int l) {

    if (d == 3) {
      for (int i = y; i < y + l + 1; i++) setBlock(x, i, CORRIDOR);
    } else if (d == 1) {
      for (int i = (y - l) + 1; i < y + 1; i++) setBlock(x, i, CORRIDOR);
    } else if (d == 2) {
      for (int i = x; i < (x + l - 1) + 1; i++) setBlock(i, y, CORRIDOR);
    } else if (d == 4) {
      for (int i = (x - l) + 1; i < x + 1; i++) setBlock(i, y, CORRIDOR);
    }
    CorrCount += 1;
  }

  void addRandomObject(int count, int ObjectID, [bool overwrite = false]) {

    for (int rc = 0; rc < count; rc++) {
      int rx = RND(Width);
      int ry = RND(Height);

      Block b = getBlock(rx, ry);
      if (b.base == VOID) {
        b.base = ObjectID;
      }
    }
  }

  void addRoom(int rx, int ry, int rw, int rh) {

    for (int i = rx; i < (rw + rx - 1) + 1; i++) {

      for (int j = ry; j < (rh + ry - 1); j++) setBlock(i, j, ROOM);
    }

    Rooms.add(new MapRectangle(rx, ry, rw, rh));
    RoomCount += 1;
  }

  void addRoomRandom() {
    int rw = 3 + RND(MaxRoomWidth - 3);
    int rh = 3 + RND(MaxRoomHeight - 3);
    int rx = 3 + RND(Width - (rw + 6));
    int ry = 3 + RND(Height - (rh + 6));
    addRoom(rx, ry, rw, rh);
  }

  void buildWall(Block currentTile, Block prevTile, Block nextTile, Block upTile, Block loTile) {
    if (prevTile.base == VOID && (currentTile.base == ROOM || currentTile.base == CORRIDOR))
      prevTile.base = WALLW;

    if (currentTile.base == VOID) {
      if (nextTile.base == ROOM || nextTile.base == CORRIDOR)
        currentTile.base = WALLW;
      else if (prevTile.base == ROOM || prevTile.base == CORRIDOR)
        currentTile.base = WALLE;
      else if (upTile.base == ROOM || upTile.base == CORRIDOR) currentTile.base = WALLS;
      else if (loTile.base == ROOM || loTile.base == CORRIDOR) currentTile.base = WALLN;
    }
  }

  void buildWallCorners(Block currentTile, Block prevTile, Block nextTile, Block upTile, Block loTile) {
    if (currentTile.base == VOID) {
      if (isBlockWall(nextTile) && isBlockWall(loTile)) currentTile.base = WALLCORNER; else if (isBlockWall(nextTile) && isBlockWall(upTile)) currentTile.base = WALLCORNER; else if (isBlockWall(prevTile) && isBlockWall(loTile)) currentTile.base = WALLCORNER; else if (isBlockWall(prevTile) && isBlockWall(upTile)) currentTile.base = WALLCORNER;
    }
  }

  void createCorridors() {

    int P1, P2;
    int Start, End;
    MapRectangle S1, S2;
    int X, Y;
    int ln;
    for (int ci = 0; ci < RoomCount - 1; ci++) {
      S1 = Rooms[ci];
      S2 = Rooms[ci + 1];

      P1 = S1.getMidPoint().x;
      P2 = S2.getMidPoint().x;

      if (P1 > P2) {
        Start = P2;
        End = P1;
        Y = S2.getMidPoint().y;
      } else {
        Start = P1;
        End = P2;
        Y = S1.getMidPoint().y;
      }
      addCorridor(Start, Y, 2, (End - Start) + 1);

      ln = End - Start;

      P1 = S1.getMidPoint().y;
      P2 = S2.getMidPoint().y;

      if (S1.getMidPoint().x > S2.getMidPoint().x)
        X = S1.getMidPoint().x;
      else
        X = S2.getMidPoint().x;

      if (P1 > P2) {
        Start = P2;
        End = P1;
      } else {
        Start = P1;
        End = P2;
      }
      addCorridor(X, Start, 3, (End - Start) + 1);
    }

  }

  void createMap([int maxrooms = 4]) {
    for (int i = 0; i < maxrooms; i++) addRoomRandom();

    createCorridors();
    createWalls();
  }

  void createWalls() {
    traverseMap(buildWall);
    traverseMap(buildWallCorners);
  }

  void generate() {
    int base = VOID;
    for (int x = 0; x < Width; x++) {
      for (int y = 0; y < Height; y++) {
        Blocks["$x-$y"] = new Block(base);
      }
    }
  }

  Block getBlock(x, y) {
    return Blocks["$x-$y"];
  }

  bool isBlockClear(int x, int y) {

    var b = getBlock(x, y);
    if (b != null) {
      if (isBlockWalkable(b.base)) return true;
    }

    return false;

  }

  int setBlock(x, y, v, [AllowOverwrite = false]) {
    try {
      if (!AllowOverwrite && Blocks["$x-$y"].base != VOID) return 1;
      Blocks["$x-$y"].base = v;
    } catch (o, e) {
      return -1;
    }
    return 0;
  }

  String show() {
    String mapo = "";

    for (int y = 0; y < Height; y++) {
      for (int x = 0; x < Width; x++) {
        if (Blocks["$x-$y"].base == VOID) mapo += " ";
        else if (isBlockWall(Blocks["$x-$y"])) mapo += "█";
        else if (Blocks["$x-$y"].base == WALLCORNER) mapo += "₪";
        else if (Blocks["$x-$y"].base == CORRIDOR) mapo += "░";
        else if (Blocks["$x-$y"].base == ROOM) mapo += "░";
        else mapo += "${Blocks["$x-$y"].base}";
      }
      mapo += "\r\n";
    }
    //print(mapo);
    return mapo;
  }

  void traverseMap(processor) {

    Block currentTile;
    Block nextTile;
    Block prevTile;
    Block upTile;
    Block loTile;

    for (int x = 1; x < Width - 2; x++) {
      for (int y = 1; y < Height - 2; y++) {

        currentTile = Blocks["$x-$y"];
        nextTile = Blocks["${x+1}-$y"];
        prevTile = Blocks["${x-1}-$y"];
        upTile = Blocks["$x-${y+1}"];
        loTile = Blocks["$x-${y-1}"];

        processor(currentTile, prevTile, nextTile, upTile, loTile);

      }
    }

  }

}
