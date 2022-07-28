// // ignore_for_file: depend_on_referenced_packages

// ignore_for_file: prefer_const_declarations, unused_local_variable, depend_on_referenced_packages

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/models/task.dart';

// import '../data/models/note.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();
  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

/*
 */
  Future _createDB(Database db, int version) async {
    final String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final String textType = 'TEXT NOT NULL';
    final String boolType = 'BOOLEAN NOT NULL';
    final String integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTasks( 
      ${TasksField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${TasksField.taskTitle} TEXT,
      ${TasksField.taskDate} TEXT,
      ${TasksField.taskStartTime} TEXT,
      ${TasksField.taskEndTime} TEXT,
      ${TasksField.taskRemindTime} TEXT,
      ${TasksField.taskRepeatTime} TEXT,
      ${TasksField.isFavourite} BOOLEAN,
      ${TasksField.isCompleted} BOOLEAN)
    ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    print('insertr');

    // final json = task.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTasks, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTasks,
      columns: TasksField.values,
      where: '${TasksField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${TasksField.taskStartTime}';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableTasks ORDER BY $orderBy');

    final result = await db.query(tableTasks, orderBy: orderBy);

    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTasks,
      where: '${TasksField.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}





//  













//   Future<int> update(Task note) async {
//     final db = await instance.database;

//     return db.update(
//       tableTasks,
//       note.toJson(),
//       where: '${TaskField.id} = ?',
//       whereArgs: [note.id],
//     );
//   }




// }
