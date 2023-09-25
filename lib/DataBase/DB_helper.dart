import 'package:sqflite/sqflite.dart';

import '../modeles/tasks.dart';

class DBHelper {
  static Database? dataBase;
// make function to make Database and make it static to call it easily
  static Future<void> onCreateDataBase() async {
    // to declare database variable with path and version
    print("Data Base Created");
    dataBase = await openDatabase(
      'ToDo.db', version: 1,
// to make creation
      onCreate: (database, version) {
        database
            .execute('CREATE TABLE ToDO(id INTEGER PRIMARY KEY , title TEXT ,'
                'date TEXT ,startTime TEXT,endTime TEXT, '
                'note TEXT,repeat TEXT,'
                'isCompleted INTEGER,'
                'color INTEGER,'
                'remind INTEGER )');
      },
      onOpen: (db) {
        DBHelper().getDataFromDataBase();
        print("Table Opened");
      },
    );
  }

  static Future insertToDataBase({
    required Tasks tasks,
  }) async {
    print("inserted raw in Table");
    // use insert and give it map to add it in table
    return await dataBase!.insert("ToDO", tasks.toJson());
  }

  static Future UpdateData(
      {required String isCompleted, required int id}) async {
    dataBase!.rawUpdate("UPDATE ToDO SET isCompleted = ?  WHERE id = ?",
        [isCompleted, id]).then((value) {
      print("Table Updated");
    });
  }

  static Future DeleteData({required int id}) async {
    print("Task Deleted");
    return await dataBase!.rawDelete("DELETE FROM ToDO  WHERE id = ?", [id]);
  }

  static Future DeleteAll() async {
    print("table Deleted");
    return await dataBase!.delete("ToDO");
  }

  Future<List<Map<String, dynamic>>>? getDataFromDataBase() {
    print("Data called from table");
    return dataBase?.rawQuery("SELECT * FROM ToDO");
  }
}
