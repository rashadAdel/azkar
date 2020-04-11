import '../abstract.dart';

class Zekr extends Model {
  final String name, about, category;
  final int target, actually, id;
  final bool isFavorite;

  Zekr({
    this.name,
    this.about,
    this.category,
    this.target,
    this.actually,
    this.id,
    this.isFavorite,
  });

  @override
  Zekr fromMap(Map<String, dynamic> map) {
    return Zekr(
      id: int.tryParse("${map['id']}"),
      name: map['name'],
      target: int.tryParse("${map['target']}"),
      actually: int.tryParse("${map['actually']}"),
      about: map['about'],
      category: map['category'],
      isFavorite: int.tryParse("${map['isFavorite']}") == 1,
    );
  }

  @override
  Map<String, dynamic> get toMap {
    return {
      "id": this.id,
      "name": this.name,
      "about": this.about,
      "target": target,
      "actually": actually,
      "category": category,
      "isFavorite": (this.isFavorite != null && this.isFavorite)
          ? 1
          : (this.isFavorite == null) ? null : 0,
    }..removeWhere((k, v) => v == null);
  }

  @override
  String get tableName => "Zekr";

  int get counter => target == 0 ? actually + 1 : target - actually;

  String get defaultWhere => "`id`=$id";
}
