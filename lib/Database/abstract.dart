import 'models/zekr.dart';
import 'Sqlite.dart';
export 'models/zekr.dart';

abstract class Model {
  const Model();

  Model fromMap(Map<String, dynamic> map);

  String get defaultWhere;

  Map<String, dynamic> get toMap;

  String get tableName;

  @override
  String toString() {
    return tableName;
  }
}

abstract class Repo {
  Future<Map<String, dynamic>> insert(
    String tableName,
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> update(
    String tableName,
    Map<String, dynamic> data,
    String where,
  );

  Future<int> delete(String tableName, String where);

  Future<List<Map<String, dynamic>>> query(String tableName, {String where});
}

class Repos<T extends Model> {
  final T _model;

  final Repo _db;

  static final zekr = Repos(Zekr(), SqlController.instance);

  Repos(this._model, this._db);

  Future<int> delete({T model, String where}) async {
    List<String> _where = [];
    model.toMap
      ..removeWhere((k, v) => v == null)
      ..forEach(
        (k, v) {
          _where.add(" `$k` = '$v' ");
        },
      );
    return await _db.delete(_model.tableName,
        where ?? _where.isNotEmpty ? _where.join(" and ") : model.defaultWhere);
  }

  Future<T> insert(T model) async {
    final Map<String, dynamic> map =
        await _db.insert(_model.tableName, model.toMap);
    return _model.fromMap(map);
  }

  Future<List<T>> query({String where}) async {
    List<T> lst = <T>[];
    final List<Map<String, dynamic>> query =
        await _db.query(_model.tableName, where: where);
    (query).forEach(
      (map) {
        lst.add(
          _model.fromMap(map),
        );
      },
    );
    return lst;
  }

  Future<T> update(T model, {String where}) async {
    return _model.fromMap(
      await _db.update(
        _model.tableName,
        model.toMap,
        where ?? model.defaultWhere,
      ),
    );
  }
}
