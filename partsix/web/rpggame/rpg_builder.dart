library rpg;
import '../mapgenerator/map_entities.dart';
import '../mapgenerator/map_procedural_generated.dart';
import 'rpg_character.dart';

buildMap(int mapwidth, int mapheight, int roomwidth, int roomheight, int roomcount) {

  PGMap mymap = new PGMap(mapwidth, mapheight, roomwidth, roomheight);
  mymap
      ..generate()
      ..createMap(roomcount)
      ..addRandomObject(mapheight * 5, TREE)
      ..addRandomItem(7, DIAMOND);

  RPGCharacter p1 = new RPGCharacter(mymap, mymap.First().x, mymap.First().y);

  List ninjasPos = mymap.addNPCs(5, NINJA);
  List<RPGCharacter> ninjas = new List<RPGCharacter>();

  ninjasPos.forEach( (p) => ninjas.add( new RPGCharacter(mymap, p[0], p[1]) ) );

  return [mymap, p1, ninjas];

}
