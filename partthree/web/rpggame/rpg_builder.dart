library rpg;
import '../mapgenerator/map_entities.dart';
import '../mapgenerator/map_procedural_generated.dart';
import 'rpg_player.dart';

buildMap(int mapwidth, int mapheight, int roomwidth, int roomheight, int roomcount) {

  PGMap mymap = new PGMap(mapwidth, mapheight, roomwidth, roomheight);
  mymap
      ..generate()
      ..createMap(roomcount)
      ..addRandomObject(roomcount * 3, TREE);

  RPGPlayer p1 = new RPGPlayer(mymap, mymap.First().x, mymap.First().y);

  return [mymap, p1];

}
