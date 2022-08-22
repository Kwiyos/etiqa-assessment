part of 'todo_bloc.dart';

class TodoState {
  final List<TodoModel> todoList;

  const TodoState(this.todoList);

  TodoState copyWith({
    List<TodoModel>? todoList,
  }) {
    return TodoState(
      todoList ?? this.todoList,
    );
  }
}
