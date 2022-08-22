import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/todoModel.dart';
import '../homeRepository.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final HomeRepository _homeRepository;

  TodoBloc(this._homeRepository) : super(const TodoState([])) {
    ///event handling
    on<onInitLoad>((event, emit) async {
      await _homeRepository.loadTodoListFromStorage();
      emit(state.copyWith(todoList: _homeRepository.getTodoList()));
    });
    on<onTodoAdded>((event, emit) async {
      _homeRepository.addTodoToList(event.todoObject);
      _homeRepository.saveTodoListToStorage();
      emit(state.copyWith(todoList: _homeRepository.getTodoList()));
    });
    on<onTodoUpdated>((event, emit) async {
      _homeRepository.updateTodoObject(event.todoObject, event.index);
      _homeRepository.saveTodoListToStorage();
      emit(state.copyWith(todoList: _homeRepository.getTodoList()));
    });
    on<onTodoStatusChanged>((event, emit) async {
      _homeRepository.updateTodoStatus(event.index, event.isChecked);
      _homeRepository.saveTodoListToStorage();
      emit(state.copyWith(todoList: _homeRepository.getTodoList()));
    });
    on<onClearAllTodo>((event, emit) async {
      await _homeRepository.clearTodoList();
      emit(state.copyWith(todoList: _homeRepository.getTodoList()));
    });
  }
}
