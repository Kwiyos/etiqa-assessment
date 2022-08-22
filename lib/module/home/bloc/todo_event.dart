part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class onInitLoad extends TodoEvent {
  const onInitLoad();

  @override
  List<Object?> get props => [];
}

class onTodoAdded extends TodoEvent {
  final TodoModel todoObject;

  const onTodoAdded(this.todoObject);

  @override
  List<Object?> get props => [todoObject];
}

class onTodoUpdated extends TodoEvent {
  final TodoModel todoObject;
  final int index;

  const onTodoUpdated(this.todoObject, this.index);

  @override
  List<Object?> get props => [todoObject, index];
}

class onTodoStatusChanged extends TodoEvent {
  final int index;
  final bool isChecked;

  const onTodoStatusChanged(this.index, this.isChecked);

  @override
  List<Object?> get props => [index, isChecked];
}

class onClearAllTodo extends TodoEvent {
  const onClearAllTodo();

  @override
  List<Object?> get props => [];
}
