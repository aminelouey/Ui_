import 'dart:io';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';

class Appointmentee {
  final int? id;
  final String name;
  final String? date;
  final String? note;
  final String? phoneNumber;

  Appointmentee({
    this.id,
    required this.name,
    this.date,
    this.note,
    this.phoneNumber,
  });

  Map<String, Object?> toMap() => {
        'Id': id,
        'Name': name,
        'Date': date,
        'Note': note,
        'Phone_Number': phoneNumber,
      };

  factory Appointmentee.fromMap(Map<String, Object?> map) => Appointmentee(
        id: map['Id'] as int?,
        name: map['Name'] as String,
        date: map['Date'] as String?,
        note: map['Note'] as String?,
        phoneNumber: map['Phone_Number'] as String?,
      );
}

class AppDatabase {
  late final Database _db;

  AppDatabase._internal() {
    final dbPath = join(
      Directory.current.path,
      'appointments.db',
    );

    _db = sqlite3.open(dbPath);
    _createTableIfNeeded();
  }

  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  void _createTableIfNeeded() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS Appointments (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT,
        Date TEXT DEFAULT (DATETIME('now','localtime')),
        Note TEXT,
        Phone_Number TEXT
      );
    ''');
  }

  int insertAppointment(Appointmentee appointment) {
    final stmt = _db.prepare('''
      INSERT INTO Appointments (Name, Date, Note, Phone_Number)
      VALUES (?, ?, ?, ?)
    ''');

    stmt.execute([
      appointment.name,
      appointment.date,
      appointment.note,
      appointment.phoneNumber,
    ]);

    stmt.dispose();
    return _db.getUpdatedRows();
  }

// ✅ Voici la seule méthode à exposer publiquement : compatible FutureBuilder
  Future<List<Appointmentee>> getAppointments() async {
    final result = getAppointmentsFormatted();
    return result.map((map) => Appointmentee.fromMap(map)).toList();
  }

  List<Map<String, dynamic>> getAppointmentsFormatted() {
    final ResultSet result = _db.select('SELECT * FROM Appointments');
    return result.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  List<Appointmentee> searchByName(String name) {
    final stmt = _db.prepare('SELECT * FROM Appointments WHERE Name LIKE ?');
    final result = stmt.select(['%$name%']);
    final list = result.map((row) => Appointmentee.fromMap(row)).toList();
    stmt.dispose();
    return list;
  }

  int updateAppointment(Appointmentee appointment) {
    final stmt = _db.prepare('''
      UPDATE Appointments SET
        Name = ?, Date = ?, Note = ?, Phone_Number = ?
      WHERE Id = ?
    ''');

    stmt.execute([
      appointment.name,
      appointment.date,
      appointment.note,
      appointment.phoneNumber,
      appointment.id,
    ]);

    stmt.dispose();
    return _db.getUpdatedRows();
  }

  int deleteAppointment(String name) {
    final stmt = _db.prepare('DELETE FROM Appointments WHERE Name = ?');
    stmt.execute([name]);
    stmt.dispose();
    return _db.getUpdatedRows();
  }

  void close() {
    _db.dispose();
  }
}
