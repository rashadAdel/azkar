import 'package:azkar/DataBase/db.dart';

class ZekrModel {
  String name, about, category;
  int target, actually, id;
  bool isFavorite;

  ZekrModel({
    this.id,
    this.name,
    this.about,
    this.target = 1,
    this.actually = 0,
    this.category,
    this.isFavorite = false,
  });

  Map<String, dynamic> get toMap => {
        "id": this.id,
        "name": this.name,
        "about": this.about,
        "target": target,
        "actually": actually,
        "category": category,
        "isFavorite": this.isFavorite ? 1 : 0,
      }..removeWhere((k, v) => v == null);

  factory ZekrModel.fromMap(Map map) {
    return ZekrModel(
      id: int.tryParse("${map['id']}"),
      name: map['name'],
      target: int.tryParse("${map['target']}"),
      actually: int.tryParse("${map['actually']}"),
      about: map['about'],
      category: map['category'],
      isFavorite: int.tryParse("${map['isFavorite']}") == 1,
    );
  }

  convertFavorate() {
    this.isFavorite = !this.isFavorite;
    update();
  }

  insert() async {
    Db.instance.insert("Zekr", toMap);
  }

  Future<int> delete() async {
    return await Db.instance.delete("Zekr", "`id`=$id");
  }

  static Future<List<ZekrModel>> fromDataBase({String where}) async {
    final List<ZekrModel> result = [];
    final data = await Db.instance.queryTable("Zekr", where: where);
    for (Map<String, dynamic> map in data) {
      result.add(ZekrModel.fromMap(map));
    }
    return result;
  }

  update({Map<String, dynamic> map}) async {
    await Db.instance.update("Zekr", map ?? toMap, "`id`=$id");
  }

  int get counter => target == 0 ? actually + 1 : target - actually;

  increment() async {
    ++actually;
    update();
  }

  reset() async {
    actually = 0;
    update();
  }
}
