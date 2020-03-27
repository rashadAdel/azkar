import 'package:azkar/DataBase/db.dart';

class ZekrModel {
  String name, about, category;
  int target, actually, id;

  ZekrModel({
    this.id,
    this.name,
    this.about,
    this.target = 0,
    this.actually = 0,
    this.category,
  });

  Map<String, dynamic> get toMap => {
        "id": this.id,
        "name": this.name,
        "about": this.about,
        "target": target,
        "actually": actually,
        "category": category,
      }..removeWhere((k, v) => v == null);

  factory ZekrModel.fromMap(Map map) {
    return ZekrModel(
      id: map['id'],
      name: map['name'],
      target: map['target'],
      actually: map['actually'],
      about: map['about'],
      category: map['category'],
    );
  }

  insert() async {
    Db.instance.insert("Zekr", toMap);
  }

  Future<int> delete({String where}) async {
    return await Db.instance.delete("Zekr", where ?? _where);
  }

  static Future<List<ZekrModel>> fromDataBase({String where}) async {
    final List<ZekrModel> result = [];
    final data = await Db.instance.queryTable("Zekr", where: where);
    for (Map<String, dynamic> map in data) {
      result.add(ZekrModel.fromMap(map));
    }
    return result;
  }

  update(ZekrModel data) async {
    await Db.instance.update("Zekr", data.toMap, _where);
  }

  String get _where {
    List<String> where = [];
    if (this.about != null) where.add("`about` = '$about'");
    if (this.actually != null && this.actually > 0)
      where.add("`actually` = $actually");
    if (this.name != null) where.add("`name` = '$name'");
    if (this.target != null && this.target > 0) where.add("`target` = $target");
    if (this.id != null) where.add("`id` = $id");
    if (this.category != null) where.add("`Category` = '$category'");
    return where.join(" and ");
  }

  int get counter => target == 0 ? actually + 1 : target - actually;

  increment() async {
    await Db.instance.update("Zekr",
        ZekrModel(actually: actually + 1, target: target).toMap, _where);
  }

  reset() async {
    await update(ZekrModel(actually: 0, target: target));
  }
}
