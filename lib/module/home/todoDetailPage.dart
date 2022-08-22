import 'package:etiqa_assessment/model/todoModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../const/colorConst.dart';

class TodoDetailPage extends StatefulWidget {
  TodoDetailPage({this.todoModel});

  TodoModel? todoModel;

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final TextEditingController _controllerTitle = TextEditingController();
  final FocusNode _focusNodeTitle = FocusNode();
  DateTime? _startDate;
  DateTime? _endDate;
  bool showError = false;

  @override
  void initState() {
    super.initState();

    /// check if add new or edit mode
    if (widget.todoModel != null) {
      _controllerTitle.text = widget.todoModel!.title;
      _startDate = widget.todoModel!.startDate;
      _endDate = widget.todoModel!.endDate;
    }

    _focusNodeTitle.addListener(() {
      if (_focusNodeTitle.hasFocus) {
        setState(() {
          showError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.todoModel == null ? 'Add new' : 'Update'} To-Do List',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          shadowColor: Colors.transparent,
          backgroundColor: ColorConst.appBarYellow,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabelText('To-Do Title'),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          maxLines: null,
                          minLines: 5,
                          controller: _controllerTitle,
                          focusNode: _focusNodeTitle,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              hintText: 'Please key in your To-Do title here',
                              border: const OutlineInputBorder(borderSide: BorderSide(), borderRadius: BorderRadius.zero)),
                        ),
                      ),
                      if (showError && _controllerTitle.text.trim().isEmpty) buildErrorText('Title cannot be empty'),
                      const SizedBox(
                        height: 10,
                      ),
                      buildLabelText('Start Date'),
                      GestureDetector(
                        onTap: () => onStartDateTap(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _startDate == null ? 'Select a date' : DateFormat('dd MMM yyyy').format(_startDate!),
                                  style: TextStyle(color: _startDate == null ? Colors.grey[400] : Colors.black),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.expand_more),
                          ),
                        ),
                      ),
                      if (showError && _startDate == null) buildErrorText('Please select a start date'),
                      const SizedBox(
                        height: 10,
                      ),
                      buildLabelText('Estimate End Date'),
                      GestureDetector(
                        onTap: () => onEndDateTap(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _endDate == null ? 'Select a date' : DateFormat('dd MMM yyyy').format(_endDate!),
                                  style: TextStyle(color: _endDate == null ? Colors.grey[400] : Colors.black),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.expand_more),
                          ),
                        ),
                      ),
                      if (showError && _endDate == null) buildErrorText('Please select an end date'),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onSubmitTap(),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  widget.todoModel == null ? 'Create Now' : 'Update',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildErrorText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.red, fontSize: 14),
    );
  }

  buildLabelText(String name) {
    return Text(
      name,
      style: const TextStyle(color: Colors.grey, fontSize: 18),
    );
  }

  onStartDateTap() async {
    _focusNodeTitle.unfocus();
    setState(() {
      showError = false;
    });
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: _startDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: _endDate ?? DateTime(DateTime.now().year + 5)); /// ensure start date always before/same as end date
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  onEndDateTap() async {
    _focusNodeTitle.unfocus();
    setState(() {
      showError = false;
    });
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: _endDate ?? (_startDate ?? DateTime.now()),
        firstDate: _startDate ?? DateTime.now(), /// ensure end date always after/same as start date
        lastDate: DateTime(DateTime.now().year + 5));
    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  onSubmitTap() {
    _focusNodeTitle.unfocus();

    /// check if all the input is valid before submit
    if (!checkIsValid()) {
      setState(() {
        showError = true;
      });
      return;
    }

    final todoObject = TodoModel(
        title: _controllerTitle.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        status: widget.todoModel?.status ?? false);

    Navigator.pop(context, todoObject);
  }

  bool checkIsValid() {
    var isValid = true;

    if (_controllerTitle.text.trim().isEmpty) {
      isValid = false;
    }

    if (_startDate == null) {
      isValid = false;
    }

    if (_endDate == null) {
      isValid = false;
    }

    return isValid;
  }
}
