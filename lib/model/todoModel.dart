import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  String title;
  DateTime startDate;
  DateTime endDate;
  bool status;

  TodoModel({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.status = false,
  });

  static Map<String, dynamic> toMap(TodoModel todoModel) => {
        'title': todoModel.title,
        'startDate': todoModel.startDate.millisecondsSinceEpoch,
        'endDate': todoModel.endDate.millisecondsSinceEpoch,
        'status': todoModel.status,
      };

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      title: map['title'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      status: map['status'] as bool,
    );
  }

  @override
  List<Object?> get props => [title, startDate, endDate, status];
}
