import 'dart:convert';

import 'package:etiqa_assessment/const/prefConst.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/todoModel.dart';

class HomeRepository {
  /// Data layer to get or modify data
  final List<TodoModel> _todoList = [];

  Future<void> loadTodoListFromStorage() async {
    List<TodoModel> todoList = [];

    final pref = await SharedPreferences.getInstance();
    final todoListEncoded = pref.getString(PrefConst.TODO_LIST);
    if (todoListEncoded != null && todoListEncoded.trim().isNotEmpty) {
      todoList.clear();
      final loadedList =
          (json.decode(todoListEncoded) as List<dynamic>).map<TodoModel>((item) => TodoModel.fromMap(item)).toList();
      todoList.addAll(loadedList);
    }

    return _todoList.addAll(todoList);
  }

  Future<void> saveTodoListToStorage() async {
    final pref = await SharedPreferences.getInstance();
    final todoListEncoded = json.encode(
      _todoList.map<Map<String, dynamic>>((todoList) => TodoModel.toMap(todoList)).toList(),
    );
    pref.setString(PrefConst.TODO_LIST, todoListEncoded);
  }

  List<TodoModel> getTodoList() {
    return _todoList;
  }

  void addTodoToList(TodoModel todoObject) => _todoList.add(todoObject);

  void updateTodoStatus(int index, bool isChecked) => _todoList[index].status = isChecked;

  void updateTodoObject(TodoModel todoObject, int index) {
    _todoList[index] = TodoModel(
        title: todoObject.title, startDate: todoObject.startDate, endDate: todoObject.endDate, status: todoObject.status);
  }

  Future<void> clearTodoList() async {
    final pref = await SharedPreferences.getInstance();
    _todoList.clear();
    pref.remove(PrefConst.TODO_LIST);
  }
}
