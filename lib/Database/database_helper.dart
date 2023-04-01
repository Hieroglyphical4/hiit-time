import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'hiit_database.db');

    // TODO Remove this after testing the database
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises(
        id INTEGER PRIMARY KEY,
        name TEXT,
        bodyPartId INTEGER,
        isCardio INTEGER,
        FOREIGN KEY (bodyPartId) REFERENCES body_parts(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE body_parts(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE weighted_workouts(
        id INTEGER PRIMARY KEY,
        exerciseId INTEGER NOT NULL,
        date INTEGER NOT NULL,
        weight INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        sets INTEGER NOT NULL,
        FOREIGN KEY (exerciseId) REFERENCES exercises (id)
      );
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  // Used to insert a record with a unique NAME
  Future<int> insertUnique(String table, Map<String, dynamic> data) async {
    final db = await database;
    final name = data['name'] as String;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE lower(name) = ?', [name.toLowerCase()]))!;
    if (count == 0) {
      return await db.insert(table, data);
    } else {
      return 0; // Return 0 to indicate that no new record was inserted
    }
  }

  /// Create new Exercise Record
  ///   Requires body_parts entry
  Future<int> insertExerciseWithBodyPartName(String exerciseName, String bodyPartName, bool isCardio) async {
    final db = await database;
    int? bodyPartId = await _getBodyPartIdByName(bodyPartName);

    if (bodyPartId == null) {
      // The body part doesn't exist yet, so insert it
      final bodyPart = {'name': bodyPartName};
      bodyPartId = await insert('body_parts', bodyPart);
    }

    final exercise = {'name': exerciseName, 'bodyPartId': bodyPartId, 'isCardio': isCardio ? 1 : 0};
    return await insertUnique('Exercises', exercise);
  }
  Future<int?> _getBodyPartIdByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('body_parts', where: 'lower(name) = ?', whereArgs: [name.toLowerCase()]);

    if (maps.isEmpty) {
      return null;
    }
    return maps.first['id'];
  }

  /// Create new Weighted Workout Record
  ///   Requires exercises entry
  Future<int> insertWeightedWorkout(String table, Map<String, dynamic> data, String exerciseName) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(exerciseName);
    data['exerciseId'] = exerciseId;

    return await db.insert(table, data);
  }
  Future<int?> _getExerciseIdByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('exercises', where: 'lower(name) = ?', whereArgs: [name.toLowerCase()]);

    if (maps.isEmpty) {
      return null;
    }
    return maps.first['id'];
  }

  /// Used to populate DropDown Menus of Exercises
  Future<List<String>> getUniqueExerciseNames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT name FROM exercises ORDER BY name ASC');
    return List<String>.from(maps.map((map) => map['name'] as String));
  }

  Future<List<Map<String, dynamic>>> getMapOfUniqueExerciseNames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT DISTINCT name FROM exercises ORDER BY name ASC');
    return maps.map((map) => {'name': map['name'], 'selected': false}).toList();
  }

  Future<List<Map<String, dynamic>>> getMapOfWorkoutsUsingExerciseName(String exerciseName) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(exerciseName);
    final List<Map<String, dynamic>> maps = await db.query(
        'weighted_workouts',
        where: 'exerciseId = ?',
        whereArgs: [exerciseId],
        orderBy: 'date DESC'
    );
    return maps;
  }

  // Used for Selects
  Future<List<Map<String, dynamic>>> getWorkout(int id) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT weighted_workouts.*, exercises.name as exerciseName
      FROM weighted_workouts
      INNER JOIN exercises ON weighted_workouts.exerciseId = exercises.id
      WHERE weighted_workouts.id = ?
      ''', [id]);
  }

  Future<int> updateWeightedWorkout(Map<String, dynamic> data, String exerciseName, int id) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(exerciseName);
    data['exerciseId'] = exerciseId;

    return await db.update('weighted_workouts', data, where: 'id = ?', whereArgs: [id]);
  }

  // Used for Selects
  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}