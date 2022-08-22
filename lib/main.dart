import 'package:etiqa_assessment/module/home/bloc/todo_bloc.dart';
import 'package:etiqa_assessment/module/home/homeRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'module/home/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(create: (_) => TodoBloc(HomeRepository()), child: HomePage()),
    );
  }
}
