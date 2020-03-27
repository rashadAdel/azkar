part of 'azkar_bloc.dart';

class AzkarState extends Equatable {
  int pos;

  ZekrModel get currentZekr => list.isNotEmpty ? list[pos] : ZekrModel();
  final List<ZekrModel> list;
  AzkarState({this.list, this.pos = 0});

  @override
  List<Object> get props => [list, pos];
}
