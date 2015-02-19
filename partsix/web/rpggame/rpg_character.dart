library rpgplayer;

class RPGCharacter {

  int x = 0;
  int y = 0;

  var gameMap;

  RPGCharacter(this.gameMap, this.x, this.y) {}

  bool canMoveTo(int dx, int dy) {
    return gameMap.isBlockClear(x + dx, y + dy);
  }

  moveU() {
    if (canMoveTo(0, -1)) y -= 1;
  }

  moveD() {
    if (canMoveTo(0, 1)) y += 1;
  }

  moveR() {
    if (canMoveTo(1, 0)) x += 1;
  }

  moveL() {
    if (canMoveTo(-1, 0)) x -= 1;
  }

}
