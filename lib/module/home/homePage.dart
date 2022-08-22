import 'package:etiqa_assessment/const/colorConst.dart';
import 'package:etiqa_assessment/model/todoModel.dart';
import 'package:etiqa_assessment/module/home/bloc/todo_bloc.dart';
import 'package:etiqa_assessment/module/home/todoDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ///calling onInitLoad bloc event to load todo list from memory
    context.read<TodoBloc>().add(const onInitLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.backgroundGrey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAddButtonTap(),
        backgroundColor: ColorConst.buttonOrange,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('To-Do List', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        shadowColor: Colors.transparent,
        backgroundColor: ColorConst.appBarYellow,
        actions: [
          TextButton(
              onPressed: () => context.read<TodoBloc>().add(const onClearAllTodo()),
              child: const Text(
                'Clear all',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.todoList.isEmpty) {
            return const Center(
              child: Text('No item in list'),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  /// loop to get todo item view
                  for (TodoModel todoObject in state.todoList) buildItemView(todoObject, state.todoList.indexOf(todoObject))
                ],
              ),
            );
          }
        },
      ),
    );
  }

  onAddButtonTap() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (builder) => TodoDetailPage()));
    if (result != null) {
      final todoObject = result as TodoModel;
      context.read<TodoBloc>().add(onTodoAdded(todoObject));
    }
  }

  onItemTap(TodoModel todoObject, int index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => TodoDetailPage(
                  todoModel: todoObject,
                )));
    if (result != null) {
      final todoObject = result as TodoModel;
      context.read<TodoBloc>().add(onTodoUpdated(todoObject, index));
    }
  }

  buildItemView(TodoModel todoObject, int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => onItemTap(todoObject, index),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todoObject.title,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Table(
                        children: [
                          const TableRow(children: [
                            Text(
                              'Start Date',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              'End Date',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              'Time left',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ]),
                          TableRow(children: [
                            Text(
                              DateFormat('dd MMM yyyy').format(todoObject.startDate),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(todoObject.endDate),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              getTimeLeft(todoObject.endDate),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: ColorConst.statusGrey,
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          todoObject.status ? 'Completed' : 'Incomplete',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Tick if completed'),
                        Checkbox(
                            value: todoObject.status,
                            onChanged: (value) => context.read<TodoBloc>().add(onTodoStatusChanged(index, value ?? false)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeLeft(DateTime endDate) {
    final timeLeft = endDate.difference(DateTime.now().subtract(const Duration(days: 1)));
    final hours = timeLeft.inHours;
    final minutes = timeLeft.inMinutes % 60;

    return '$hours hrs $minutes min';
  }
}
