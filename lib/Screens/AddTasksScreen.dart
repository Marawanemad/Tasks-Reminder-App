import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskreminder/Components/Widgets.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Components/themes.dart';
import 'package:taskreminder/controller/taskController.dart';
import 'package:taskreminder/modeles/tasks.dart';

// ignore: must_be_immutable
class AddTasksScreen extends StatefulWidget {
  AddTasksScreen({super.key});

  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  int SelectedReminder = 5;

  List<int> remindList = [5, 10, 15, 20];
  var formkey = GlobalKey<FormState>();

  String SelectedRepeated = 'None';
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int SelectedItemColor = 0;
  String date = DateFormat.yMd().format(DateTime.now());
  String StartTime = DateFormat("HH:mm").format(DateTime.now());
  String EndTime = DateFormat("HH:mm")
      .format(DateTime.now().add(const Duration(minutes: 30)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // taskController().getTasks();
            Get.back();
          },
        ),
        title: Text(
          "Add Task",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("images/person.jpeg"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                textForm(
                  controller: titleController,
                  textinputaction: TextInputAction.next,
                  title: "Title",
                  hint: "Enter the title here.",
                  context: context,
                ),
                const SizedBox(height: 20),
                textForm(
                    controller: noteController,
                    textinputaction: TextInputAction.done,
                    title: "Note",
                    hint: "Enter note here.",
                    context: context),
                const SizedBox(height: 20),
                textForm(
                    title: "Date",
                    hint: date,
                    widget: IconButton(
                      onPressed: () => getDateFunc(),
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                    context: context),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: textForm(
                        title: "Start Time",
                        hint: StartTime,
                        widget: IconButton(
                            onPressed: () => getTimeFunc(isStartTime: true),
                            icon: const Icon(Icons.watch_later_outlined)),
                        context: context,
                      ),
                    ),
                    Expanded(
                      child: textForm(
                        title: "End Time",
                        hint: EndTime,
                        widget: IconButton(
                            onPressed: () => getTimeFunc(isStartTime: false),
                            icon: const Icon(Icons.watch_later_outlined)),
                        context: context,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                textForm(
                  title: "Reminder",
                  hint: "$SelectedReminder minutes early.",
                  // to make button when pressed on it show menu
                  widget: dropDownButton(
                    context: context,
                    item: remindList,
                    onChange: (newValue) {
                      setState(
                        () {
                          SelectedReminder = newValue!;
                        },
                      );
                    },
                  ),
                  context: context,
                ),
                const SizedBox(height: 20),
                textForm(
                    title: "Repeat",
                    hint: SelectedRepeated,
                    // to make button when pressed on it show menu
                    widget: dropDownButton(
                        context: context,
                        item: repeatList,
                        onChange: (newValue) {
                          setState(() {
                            SelectedRepeated = newValue!;
                          });
                        }),
                    context: context),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Color",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Row(
                          children: [
                            Wrap(
                              children: List<Widget>.generate(
                                3,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      SelectedItemColor = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: CircleAvatar(
                                        backgroundColor: index == 0
                                            ? themes().RedCol
                                            : index == 1
                                                ? themes().Pink2Col
                                                : themes().OrangeCol,
                                        child: SelectedItemColor == index
                                            ? Icon(
                                                Icons.done,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              )
                                            : null),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    // to make any child in it enable to press
                    GestureDetector(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          addTaskToDataBase();
                          Get.back();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: themes().PinkCol,
                        ),
                        child: Text(
                          "Create Task",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  addTaskToDataBase() async {
    await taskController().addTask(
      task: Tasks(
        title: titleController.text,
        note: noteController.text,
        isCompleted: 0,
        date: date,
        startTime: StartTime,
        endTime: EndTime,
        color: SelectedItemColor,
        remind: SelectedReminder,
        repeat: SelectedRepeated,
      ),
    );
  }

  getDateFunc() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2050))
        .then((value) {
      if (value != null) {
        setState(() {
          date = DateFormat.yMd().format(value).toString();
        });
      }
    });
  }

  getTimeFunc({required bool isStartTime}) {
    showTimePicker(
            context: context,
            initialTime: isStartTime
                ? TimeOfDay.now()
                : TimeOfDay.fromDateTime(
                    DateTime.now().add(const Duration(minutes: 30))))
        .then((value) {
      if (value != null) {
        setState(() {
          isStartTime
              ? StartTime = value.format(context).toString()
              : EndTime = value.format(context).toString();
        });
      }
    });
  }
}
