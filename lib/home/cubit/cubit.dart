import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_app/home/cubit/states.dart';
import 'package:simple_todo_app/home/model/task_model.dart';
import 'package:simple_todo_app/resources/enums.dart';
import 'package:sqflite/sqflite.dart';

class HomeCubit extends Cubit<HomeCubitStates> {
  HomeCubit() : super(InitialHomeState());

  static HomeCubit get(context) => BlocProvider.of(context);
  Map<String, List<TaskModel>> tasksMap = {
    Status.New.name: [],
    Status.done.name: [],
    Status.archived.name: [],
  };
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  // static Size size(context) => MediaQuery.sizeOf(context);
  bool edit = true;
  int navBarIndex = 0;
  late Database database;

  void timePickerFunction() {}

  void datePickerFunction() {}

// var key = GlobalKey<>();
  void updateNavBarIndex(int index) {
    navBarIndex = index;
    emit(UpdateNavBarIndexState());
  }

  void bottomSheetButton(BuildContext contex,
      {required Widget bottomSheetWidget}) {
    showBottomSheet(context: contex, builder: (context) => bottomSheetWidget);
  }

  void changeBottomSheetStatus() {}

  void archiveTask() {}

  void doneTask() {}

  Future<void> createOpenDatabase() async {
    await openDatabase("tasks", version: 1,
        onCreate: (Database db, int version) async {
      if (kDebugMode) {
        print("Database created");
      }
      await db.execute(
          'CREATE TABLE Task (id INTEGER PRIMARY KEY, task TEXT, time TEXT, date TEXT, status TEXT)');
    }, onOpen: (Database db) {
      if (kDebugMode) {
        print("Database opened");
      }
    }).then((value) => database = value);
  }

  Future<void> insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      /*int id1 = await txn.rawInsert(
          'INSERT INTO Task(task, time, date,status) VALUES("${title}", "${time}", "${date}","New")');
      print('inserted: $id1');*/
      int id1 = await txn.rawInsert(
          'INSERT INTO Task(task, time, date,status) VALUES(?, ?, ?,?)',
          [title, time, date, Status.New.name]);
      if (kDebugMode) {
        print('inserted: $id1');
      }
    });
  }

  Future<TaskModel> getFromDatabase() async {
    TaskModel model;
    model =
        TaskModel( id: 0,taskContent: '', taskTime: '', taskDate: '', taskStatus: '',);
    return model;
  }

  Future<void> updateRecordInDatabase(
      {required int id, required String status}) async {
    int count = await database
        .rawUpdate('UPDATE Task SET task = ? WHERE id = ?', [status, id]);
    if (kDebugMode) {
      print('updated: $count');
    }
  }

  Future<void> deleteRecordFromDatabase({required int id}) async {
    int count = await database.rawDelete('DELETE FROM Task WHERE id = ?', [id]);
    if (kDebugMode) {
      print('deleted: $count');
    }
  }
}
