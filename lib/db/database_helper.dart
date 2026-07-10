import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Central local database (SQLite via sqflite). One file, one connection,
/// reused everywhere via DatabaseHelper.instance.
///
/// NOTE on passwords: stored as plain text for demo simplicity. For a real
/// production app, hash passwords (e.g. bcrypt) before storing — flagged
/// here intentionally rather than hidden.
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'studymate.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        college TEXT,
        department TEXT,
        semester TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        datetime TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        topic TEXT NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE calendar_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        title TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE timetable_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        file_name TEXT NOT NULL,
        file_path TEXT NOT NULL,
        uploaded_at TEXT NOT NULL
      )
    ''');
  }

  // ---------------- USERS ----------------

  Future<int> registerUser(Map<String, dynamic> user) async {
    final db = await database;
    return db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final rows = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  /// Returns the user row if email+password match, else null.
  Future<Map<String, dynamic>?> validateLogin(String email, String password) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  // ---------------- NOTES ----------------

  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    return db.insert('notes', note);
  }

  Future<List<Map<String, dynamic>>> getNotes(int userId) async {
    final db = await database;
    return db.query('notes', where: 'user_id = ?', whereArgs: [userId], orderBy: 'id DESC');
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- REMINDERS ----------------

  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    return db.insert('reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getReminders(int userId) async {
    final db = await database;
    return db.query('reminders', where: 'user_id = ?', whereArgs: [userId], orderBy: 'datetime ASC');
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- QUIZ RESULTS ----------------

  Future<int> insertQuizResult(Map<String, dynamic> result) async {
    final db = await database;
    return db.insert('quiz_results', result);
  }

  Future<List<Map<String, dynamic>>> getQuizResults(int userId) async {
    final db = await database;
    return db.query('quiz_results', where: 'user_id = ?', whereArgs: [userId], orderBy: 'id DESC');
  }

  // ---------------- CALENDAR EVENTS ----------------

  Future<int> insertCalendarEvent(Map<String, dynamic> event) async {
    final db = await database;
    return db.insert('calendar_events', event);
  }

  Future<List<Map<String, dynamic>>> getCalendarEvents(int userId) async {
    final db = await database;
    return db.query('calendar_events', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date ASC');
  }

  Future<int> deleteCalendarEvent(int id) async {
    final db = await database;
    return db.delete('calendar_events', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------- TIMETABLE FILES ----------------

  Future<int> insertTimetableFile(Map<String, dynamic> file) async {
    final db = await database;
    return db.insert('timetable_files', file);
  }

  Future<List<Map<String, dynamic>>> getTimetableFiles(int userId) async {
    final db = await database;
    return db.query('timetable_files', where: 'user_id = ?', whereArgs: [userId], orderBy: 'id DESC');
  }

  Future<int> deleteTimetableFile(int id) async {
    final db = await database;
    return db.delete('timetable_files', where: 'id = ?', whereArgs: [id]);
  }
}
