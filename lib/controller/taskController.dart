import 'package:get/get.dart';
import 'package:taskreminder/DataBase/DB_helper.dart';
import 'package:taskreminder/modeles/tasks.dart';

class taskController extends GetxController {
  // obs to can listen on the list in another classes
  static RxList<Tasks> tasksList = <Tasks>[].obs;

  addTask({required Tasks task}) {
    DBHelper.insertToDataBase(tasks: task);
    getTasks();
  }

  static getTasks() async {
    List<Map<String, dynamic>>? tasks = await DBHelper().getDataFromDataBase();
    tasksList.assignAll(tasks?.map((e) => Tasks.fromJson(e)) ?? []);
  }

  deleteTasks({required int id}) async {
    await DBHelper.DeleteData(id: id);
    getTasks();
  }

  deleteAllTasks() async {
    await DBHelper.DeleteAll();
    getTasks();
  }

  UpdateTasks({required String isCompleted, required int id}) async {
    await DBHelper.UpdateData(isCompleted: isCompleted, id: id);
    getTasks();
  }
}
