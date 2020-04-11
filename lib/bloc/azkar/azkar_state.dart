part of 'azkar_bloc.dart';

class AzkarState extends Equatable {
  int pos;

  String title;
  Zekr get currentZekr => list.isNotEmpty ? list[pos] : Zekr();
  final List<Zekr> list;

  AzkarState({
    String title,
    this.list,
    this.pos = 0,
  }) {
    this.title = title ?? "نتائج البحث ${list.length}";
  }
  @override
  List<Object> get props => [list, pos, title];
}
