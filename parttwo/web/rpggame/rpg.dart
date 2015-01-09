library rpg;
import '../mapgenerator/map_entities.dart';
import '../mapgenerator/procedural_generated_map.dart';

PGMap buildMap(int mapwidth, int mapheight, int roomwidth, int roomheight, int roomcount) {

  PGMap mymap = new PGMap(mapwidth, mapheight, roomwidth, roomheight);
  mymap
      ..generate()
      ..createMap(roomcount)
      ..addRandomObject(roomcount * 3, TREE);
  return mymap;

}
