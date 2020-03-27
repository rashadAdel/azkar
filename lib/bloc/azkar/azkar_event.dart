part of 'azkar_bloc.dart';

abstract class AzkarEvent extends Equatable {
  const AzkarEvent();
}

class RefreshData extends AzkarEvent {
  const RefreshData();
  @override
  List<Object> get props => [];
}

class ChangePosition extends AzkarEvent {
  final int pos;

  const ChangePosition(this.pos);

  @override
  List<Object> get props => [pos];
}

class AddOrUpdate extends AzkarEvent {
  final BuildContext context;
  final ZekrModel zekr;

  const AddOrUpdate({@required this.context, this.zekr});

  @override
  List<Object> get props => [context, zekr];
}

class OpenCategory extends AzkarEvent {
  final BuildContext context;
  final String categoryName;

  const OpenCategory({@required this.context, @required this.categoryName});

  @override
  List<Object> get props => [context, categoryName];
}

class Increment extends AzkarEvent {
  const Increment();
  @override
  List<Object> get props => null;
}

class Reset extends AzkarEvent {
  const Reset();
  @override
  List<Object> get props => null;
}

class Delete extends AzkarEvent {
  const Delete();

  @override
  List<Object> get props => null;
}
