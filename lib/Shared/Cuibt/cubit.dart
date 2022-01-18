
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thisapp/Shared/Cuibt/states.dart';
import 'package:thisapp/modules/Archive%20Task%20Screen/archive_task_screen.dart';
import 'package:thisapp/modules/Done%20Task%20Screen/done_task_screen.dart';
import 'package:thisapp/modules/New%20Task%20Screen/new_task_screen.dart';

class AppCubit extends Cubit <AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  List<String> title =
  [
    'New Task',
    'Done Task',
    'Archive Task',
  ];

  void ChangeIndexforBottomNavigationBar (int index)
  {
    currentIndex = index;
    emit(AppBottomNavigationBarIndexState());
  }

  late Database database;
  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archiveTask = [];

  void creatDatabase()
  {
    openDatabase(
        'this.db',
        version: 1,

        onCreate: (database, version)
        {
          print('Database Created');

          database.execute(
              'CREATE TABLE agin(id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)'
          ).then((value) {print('Table Created');}
          ).catchError((onError){print('OnCreate Database error $onError');});
        },

        onOpen: (database)
        {
          getDataFromDatabase(database);

          print('Database Opened');
        }
    ).then((value)
    {
      database = value;
      emit(AppCreatDatabaseState());
    }
    );
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async
  {
    await database.transaction((txn)
    {
      return txn.rawInsert(
          'INSERT INTO agin(title, data, time, status) VALUES("$title", "$date", "$time", "new")'
      ).then((value){
        print('$value Inserted Successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }
      ).catchError((onError){print('Inserted Database Error $onError');});
    }
    );
  }

  void getDataFromDatabase(database)
  {
    newTask = [];
    doneTask = [];
    archiveTask = [];

    database.rawQuery('SELECT * FROM agin').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTask.add(element);
        else if (element['status'] == 'done')
          doneTask.add(element);
        else archiveTask.add(element);
      }
      );
      emit(AppGetDatabaseState());
    });
  }

  void UpdateData ({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE agin SET status = ? WHERE id = ?',
        ['$status', id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void DeletData ({required int id}) {
    database.rawDelete('DELETE FROM agin WHERE id = ?', [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


  bool isbottomSheet = false;
  Icon iconfab = const Icon(Icons.edit);

  void ChangeBottomSheet ({required bool isShow, required Icon icon})
  {
    isbottomSheet = isShow;
    iconfab = icon;

    emit(AppChangeBottomSheetState());
  }


}