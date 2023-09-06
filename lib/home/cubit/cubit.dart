import 'dart:developer';

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
  bool bottomSheetOpen = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Database? database;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void timePickerFunction(BuildContext context) {
     showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
       timeController.text = value!.format(context);
     });
  }

  void datePickerFunction(BuildContext context) {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year+100)).then((value) => dateController.text=value.toString().substring(0,10));
  }

// var key = GlobalKey<>();
  void updateNavBarIndex(int index) {
    navBarIndex = index;
    emit(UpdateNavBarIndexState());
  }

  void bottomSheetButton(BuildContext contex,
      {required Widget bottomSheetWidget}) {
    if (bottomSheetOpen) {
      if (formKey.currentState!.validate()) {
        insertIntoDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text)
            .then((value) {
          log("Data inserted into the database successfully");

          titleController.text = '';
          timeController.text = '';
          dateController.text = '';
          bottomSheetOpen = false;
          emit(BottomSheetClosed());
          Navigator.pop(contex);
        });
      }
    } else {
      bottomSheetOpen = true;

      emit(BottomSheetOpened());

      scaffoldKey.currentState
          ?.showBottomSheet((context) => bottomSheetWidget)
          .closed
          .then((value) {
        titleController.text = '';
        timeController.text = '';
        dateController.text = '';
        bottomSheetOpen = false;
        emit(BottomSheetClosed());
// print("bottom sheet value ===> $value");
      });
    }
  }

  /* void changeBottomSheetStatus() {}

  Future<void> archiveTask({required int id}) async{
    emit(LoadingUpdateDataBaseElement());
    await updateRecordInDatabase(id: id,status: Status.archived.name).then((value) => emit(DoneUpdateDataBaseElement())).catchError((e){
      log("updating the element id = $id failed ==> ${e.toString()}");
      emit(ErrorUpdateDataBaseElement());
    });
  }

  Future<void> doneTask({required int id}) async{
    emit(LoadingUpdateDataBaseElement());
    await updateRecordInDatabase(id: id,status: Status.done.name).then((value) => emit(DoneUpdateDataBaseElement())).catchError((e){
      log("updating the element id = $id failed ==> ${e.toString()}");
      emit(ErrorUpdateDataBaseElement());
    });
  }
*/
  Future<void> createOpenDatabase() async {
    await openDatabase("tasks", version: 1,
        onCreate: (Database db, int version) async {
      log("Database created");

      await db.execute(
          'CREATE TABLE Task (id INTEGER PRIMARY KEY, task TEXT, time TEXT, date TEXT, status TEXT)');
    }, onOpen: (Database db) {
      log("Database opened");
    }).then((value) async {
      database = value;
      await getFromDatabase();
    });
  }

  Future<void> insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    emit(LoadingInsertedDataBase());
    await database!
        .transaction((txn) async {
          /*int id1 = await txn.rawInsert(
          'INSERT INTO Task(task, time, date,status) VALUES("${title}", "${time}", "${date}","New")');
      print('inserted: $id1');*/
          await txn.rawInsert(
              'INSERT INTO Task(task, time, date,status) VALUES(?, ?, ?,?)',
              [title, time, date, Status.New.name]).then((value)  {
            log('inserted: $value');
            (tasksMap[Status.New.name] ?? []).add(TaskModel(
              id: value,
                taskContent: title,
                taskTime: time,
                taskDate: date,
                taskStatus: Status.New.name));
            emit(DoneInsertedDataBase());
          /*  await getFromDatabase()
                .then((value) => );*/
          }).catchError((e) {
            log("inserting the element title = $title failed ==> ${e.toString()}");
            emit(ErrorInsertedDataBase());
          });
        })
        .then((value) => emit(SuccessfulDataBaseTransaction()))
        .catchError((e) {
          log("Database transaction failed ==> ${e.toString()}");
          emit(ErrorDataBaseTransaction());
        });
  }

  Future<void> getFromDatabase() async {
    emit(LoadingGetDataBase());
    tasksMap = {
      Status.New.name: [],
      Status.done.name: [],
      Status.archived.name: [],
    };
    await database!.rawQuery('SELECT * FROM Task').then((value) {
      if (value.isNotEmpty) {
        for (int index = 0; index < value.length; index++) {
          int? itemId = value[index]['id'] as int?;
          String? itemContent = value[index]['task'] as String?;
          String? itemTime = value[index]['time'] as String?;
          String? itemDate = value[index]['date'] as String?;
          String? itemStatus = value[index]['status'] as String?;
          (tasksMap[itemStatus ?? Status.New.name] ?? []).add(TaskModel(
              id: itemId!,
              taskContent: itemContent!,
              taskTime: itemTime!,
              taskDate: itemDate!,
              taskStatus: itemStatus!));
        }
        if ((tasksMap[Status.New.name] ?? []).isEmpty) {
          emit(EmptyNewTasks());
        } else if ((tasksMap[Status.done.name] ?? []).isEmpty) {
          emit(EmptyDoneTasks());
        } else if ((tasksMap[Status.archived.name] ?? []).isEmpty) {
          emit(EmptyArchivedTasks());
        } else {
          emit(DoneGetDataBase());
        }
        return [];
      } else {
        emit(EmptyTasksState());
        return [];
      }
    });
  }

  Future<void> updateRecordInDatabase(
      {required int id, required String status}) async {
    emit(LoadingUpdateDataBaseElement());

    await database!.rawUpdate('UPDATE Task SET status = ? WHERE id = ?',
        [status, id]).then((value) async {
      log('updated: $value');
      await getFromDatabase().then((value) {
        emit(DoneUpdateDataBaseElement());
      });
    }).catchError((e) {
      log("updating the element id = $id failed ==> ${e.toString()}");
      emit(ErrorUpdateDataBaseElement());
    });
  }

  Future<void> deleteRecordFromDatabase({required int id}) async {
    emit(LoadingDeleteDataBaseElement());
    await database!
        .rawDelete('DELETE FROM Task WHERE id = ?', [id]).then((value) async{
      log('deleted: $value');
    await  getFromDatabase().then((value) => emit(DoneDeleteDataBaseElement()));
    }).catchError((e) {
      log("deleting the element id = $id failed ==> ${e.toString()}");
    });
  }
}
