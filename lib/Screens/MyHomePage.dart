import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Components/themes.dart';
import 'package:taskreminder/Screens/AddTasksScreen.dart';
import 'package:taskreminder/Services/NotificationService.dart';
import 'package:taskreminder/controller/taskController.dart';

import '../Services/ThemeServices.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late NotifyHelper notifyhelper;
  @override
  void initState() {
    super.initState();

    notifyhelper = NotifyHelper();
    notifyhelper.initializeNotification();
    taskController.getTasks();
  }

  DateTime SelectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Get.isDarkMode
              ? Icons.light_mode_sharp
              : Icons.nightlight_round_outlined),
          onPressed: () {
            ThemeService().switchTheme();
            notifyhelper.DisplatNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? "The Theme has been light"
                    : "The Theme has been dark");
          },
        ),
        actions: [
          // button to delete all data
          IconButton(
            iconSize: 45,
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Alert",
                      style: Theme.of(context).textTheme.headlineLarge),
                  content: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Are you sure you want to delete data ?',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Spacer(),
                          SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => themes().PinkCol)),
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      "Close",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => themes().RedCol)),
                                    onPressed: () {
                                      taskController().deleteAllTasks();
                                      NotifyHelper().cancelAllNotification();
                                      Get.back();
                                    },
                                    child: Text(
                                      "Delete",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("images/person.jpeg"),
            ),
          )
        ],
      ),
      body: Column(children: [
        TaskBar(),
        const SizedBox(height: 10),
        DateBar(),
        const SizedBox(height: 10),
        ShowTasks(),
      ]),
    );
  }

// to show date and button will appear above the datepicker
  TaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Today",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
              GestureDetector(
                // to make navigate to AddTasksScreen use GetX state mangement
                onTap: () => Get.to(() => AddTasksScreen()),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themes().PinkCol,
                  ),
                  child: Text(
                    "+ Add Task",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// to make datepicker will show
  DateBar() {
    return Container(
        margin: const EdgeInsets.only(left: 20, top: 6),
        // libirary use to make list of date
        child: DatePicker(
          DateTime.now(),
          initialSelectedDate: SelectedDate,
          width: 70,
          height: 100,
          selectedTextColor: Theme.of(context).textTheme.headlineLarge!.color!,
          dateTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey[400]),
          monthTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey[400]),
          dayTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.grey[400]),
          selectionColor: themes().PinkCol,
          onDateChange: (newDate) {
            setState(() {
              SelectedDate = newDate;
            });
          },
        ));
  }

  bool getsnackbar = false;
// to show the widgets tasks or the NoTaskMSG design
  ShowTasks() {
    // to make listView inside Column without any errors
    return Expanded(
      child: Obx(() {
        if (taskController.tasksList.isEmpty) {
          return NoTaskMSG(
              theNoTaskText:
                  "You do not have any tasks yet!\nAdd new tasks to make your days productive .");
        } else {
          return RefreshIndicator(
            onRefresh: onRefreshing,
            child: ListView.builder(
              itemBuilder: (context, index) {
                var task = taskController.tasksList[index];

                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(SelectedDate) ||
                    // to check if task in every week or know if yes show it every week by this equation
                    (task.repeat == 'Weekly' &&
                        SelectedDate.difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        SelectedDate.day ==
                            DateFormat.yMd().parse(task.date!).day)) {
                  String s = '${task.title}|${task.note}|${task.startTime}|';
                  print(s.split('|')[2]);

                  getsnackbar = false;
                  NotifyHelper().scheduledNotification(
                      int.parse(task.startTime.toString().split(':')[0]),
                      int.parse(task.startTime.toString().split(':')[1]),
                      task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: TaskTile(
                          context: context,
                          task: taskController.tasksList[index],
                          id: taskController.tasksList[index].id,
                        ),
                      ),
                    ),
                  );
                } else {
                  // to delete any task not repeat before today
                  if (DateFormat.yMd()
                          .parse(task.date!)
                          .day
                          .isLowerThan(DateTime.now().day) &&
                      task.repeat == "None") {
                    taskController().deleteTasks(id: task.id!);
                  }
                  getsnackbar = true;

                  return Container();
                }
              },
              itemCount: taskController.tasksList.length,
            ),
          );
        }
      }),
    );
  }

  Future onRefreshing() async {
    await taskController.getTasks();
    print(getsnackbar);
    if (taskController.tasksList.isEmpty || getsnackbar == true) {
      // to show alert message
      Get.snackbar(
        "Sorry",
        "We Did not Find any data to show it please add tasks.",
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.35,
            right: 10,
            left: 10),
        backgroundColor: themes().RedCol,
      );
    }
  }

// to make if no tasks what shape will appear
  NoTaskMSG({required String theNoTaskText}) {
    return RefreshIndicator(
      onRefresh: onRefreshing,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'images/task.svg',
                height: 200,
                semanticsLabel: 'Task',
                // to change color and blindMode.srcIn to change only icon color
                colorFilter:
                    ColorFilter.mode(themes().PinkCol, BlendMode.srcIn),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                child: Text(
                  theNoTaskText,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 31),
            ],
          ),
        ),
      ),
    );
  }

// to make tasks shape
  TaskTile({required context, required task, required id}) {
    // to make object from class tasks
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 10),
      // make tasks enable to clicked to show the bottomSheet
      child: GestureDetector(
        onTap: () {
          showBottomSheet(context, task);
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: chooseColor(task.color),
          ),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Theme.of(context).iconTheme.color,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${task.startTime} - ${task.endTime}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(task.note!,
                      style: Theme.of(context).textTheme.bodyMedium)
                ],
              )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: 0.5,
                color: Colors.black.withOpacity(0.7),
              ),
              // to make container but routate
              RotatedBox(
                // to make it routate in the third quarter
                quarterTurns: 3,
                child: Text(
                  task.isCompleted == 0 ? 'TODO' : 'Completed',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// to choose task tile color
  chooseColor(int? color) {
    switch (color) {
      case 0:
        return themes().RedCol;
      case 1:
        return themes().Pink2Col;
      case 2:
        return themes().OrangeCol;
      default:
        return themes().RedCol;
    }
  }

// make bottomSheet buttons when pressed on task
  BuildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color color,
      bool isClosed = false}) {
    // to make the buttons appeared in bottomSheet
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            // to make border
            border: Border.all(
                width: 2, color: isClosed ? Colors.grey[300]! : color),
            borderRadius: BorderRadius.circular(20),
            color: isClosed ? Colors.transparent : color),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 25),
          ),
        ),
      ),
    );
  }

// make the buttomsheet
  showBottomSheet(BuildContext context, task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.width * 0.8,
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // to make shape in the top of buttomSheet
            Flexible(
              child: Container(
                height: 4,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //  to make button complete if task is not compelete and not appear any thing if completed
            task.isCompleted == 1
                ? BuildBottomSheet(
                    label: 'Task Not Compeleted',
                    onTap: () {
                      taskController()
                          .UpdateTasks(isCompleted: "0", id: task.id);
                      Get.back();
                      print("Task return to ToDo");
                    },
                    color: themes().PinkCol)
                : BuildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      taskController()
                          .UpdateTasks(isCompleted: "1", id: task.id);
                      Get.back();
                      print("Task become Compelet");
                    },
                    color: themes().PinkCol),
            // to make delete button
            BuildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  notifyhelper.cancelNotification(task);
                  taskController().deleteTasks(id: task.id);
                  Get.back();
                },
                color: themes().PinkCol),
            const Divider(color: Colors.grey),
            // to make cancel button
            BuildBottomSheet(
                label: 'Cancel',
                onTap: () => Get.back(),
                color: themes().PinkCol),
          ],
        ),
      ),
    );
  }
}
