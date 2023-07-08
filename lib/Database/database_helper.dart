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
      version: 2,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises(
        id INTEGER PRIMARY KEY,
        name TEXT,
        isCardio INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE weighted_workouts(
        id INTEGER PRIMARY KEY,
        exerciseId INTEGER NOT NULL,
        date INTEGER NOT NULL,
        weight INTEGER NOT NULL,
        rep1 INTEGER NOT NULL,
        rep2 INTEGER NOT NULL,
        rep3 INTEGER NOT NULL,
        rep4 INTEGER NOT NULL,
        FOREIGN KEY (exerciseId) REFERENCES exercises (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE cardio_workouts(
        id INTEGER PRIMARY KEY,
        exerciseId INTEGER NOT NULL,
        date INTEGER NOT NULL,
        workTime INTEGER NOT NULL,
        restTime INTEGER NOT NULL,
        intervals INTEGER NOT NULL,
        FOREIGN KEY (exerciseId) REFERENCES exercises (id)
      );
    ''');
  }

  /// Setter
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  /// Getter:
  Future<int?> getIdByName(String table, String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table, where: 'lower(name) = ?', whereArgs: [name.toLowerCase()]);

    if (maps.isEmpty) {
      return null;
    }
    return maps.first['id'];
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
  Future<int> insertExercise(String exerciseName, bool isCardio) async {
    final db = await database;

    final exercise = {'name': exerciseName.toLowerCase(), 'isCardio': isCardio ? 1 : 0};
    return await insertUnique('Exercises', exercise);
  }

  /// Create new Workout Record
  ///   Requires previous exercises entry
  Future<int> insertWorkout(String table, Map<String, dynamic> data, String exerciseName) async {
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
    // Each Section of workouts will begin with a Header
    List<String> exerciseNameList = ['--CardioExercisesBegin'];

    // Add Cardio exercise to the list first
    final List<Map<String, dynamic>> cardioExerciseQuery = await db.rawQuery(
        'SELECT DISTINCT name FROM exercises WHERE isCardio = 1 ORDER BY lower(name) ASC'
    );
    exerciseNameList.addAll(cardioExerciseQuery.map<String>((exercise) => exercise['name'].toString()));

    // Add Weighted Exercise Second
    exerciseNameList.add('--WeightedExercisesBegin');
    final List<Map<String, dynamic>> weightedExerciseQuery = await db.rawQuery(
        'SELECT DISTINCT name FROM exercises WHERE isCardio = 0 ORDER BY lower(name) ASC'
    );
    exerciseNameList.addAll(weightedExerciseQuery.map<String>((exercise) => exercise['name'].toString()));

    return exerciseNameList;
  }

  Future<List<Map<String, dynamic>>> getMapOfUniqueWeightedExerciseNames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT DISTINCT name FROM exercises WHERE isCardio = 0 ORDER BY name ASC');
    return maps.map((map) => {'name': map['name'], 'selected': false}).toList();
  }

  Future<List<Map<String, dynamic>>> getMapOfUniqueCardioExerciseNames() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT DISTINCT name FROM exercises WHERE isCardio = 1 ORDER BY name ASC');
    return maps.map((map) => {'name': map['name'], 'selected': false}).toList();
  }

  Future<List<Map<String, dynamic>>> getMapOfWorkoutsUsingExerciseName(String exerciseName, bool isCardio, String sortOrder) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(exerciseName);
    List<Map<String, dynamic>> maps;

    if (isCardio) {
      maps = await db.query(
          'cardio_workouts',
          where: 'exerciseId = ?',
          whereArgs: [exerciseId],
          orderBy: sortOrder
      );
    } else {
      maps = await db.query(
          'weighted_workouts',
          where: 'exerciseId = ?',
          whereArgs: [exerciseId],
          orderBy: sortOrder
      );
    }

    return maps;
  }

  // Used for Selects on Weighted Workouts Table
  Future<List<Map<String, dynamic>>> getWeightedWorkout(int id) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT weighted_workouts.*, exercises.name as exerciseName
      FROM weighted_workouts
      INNER JOIN exercises ON weighted_workouts.exerciseId = exercises.id
      WHERE weighted_workouts.id = ?
      ''', [id]);
  }

  // Used for Selects on Cardio Workouts Table
  Future<List<Map<String, dynamic>>> getCardioWorkout(int id) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT cardio_workouts.*, exercises.name as exerciseName
      FROM cardio_workouts
      INNER JOIN exercises ON cardio_workouts.exerciseId = exercises.id
      WHERE cardio_workouts.id = ?
      ''', [id]);
  }

  // To determine if an Exercise is Cardio
  Future<Object?> isExerciseCardio(String exerciseName) async {
    final db = await database;
    final exercisesQuery = await db.rawQuery('''
      SELECT isCardio
      FROM exercises
      WHERE exercises.name = ?
      ''', [exerciseName]);

    return exercisesQuery.first['isCardio'];
  }

  Future<int> updateWorkout(Map<String, dynamic> data, String exerciseName, int id, String table) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(exerciseName);
    data['exerciseId'] = exerciseId;

    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExercise(String exerciseName, String initialExerciseName) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(initialExerciseName);

    Map<String, dynamic> data = {
      'name': exerciseName,
    };

    return await db.update('exercises', data, where: 'id = ?', whereArgs: [exerciseId]);
  }

  // Delete a Give Exercise from the Database
  Future<int> deleteExercise(String exerciseName) async {
    final db = await database;
    int? exerciseId = await _getExerciseIdByName(exerciseName);

    return await db.delete('exercises', where: 'id = ?', whereArgs: [exerciseId]);
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