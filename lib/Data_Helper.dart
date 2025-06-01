// Update patient's treatment
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataHelper {
  static final DataHelper _instance = DataHelper._internal();
  factory DataHelper() => _instance;

  static Database? _db;

  DataHelper._internal();

  // Access the database (open if not already open)
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initialize database (create file, schema, tables, triggers)
  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: (db) async {
        // Enable advanced SQLite settings
        await db.execute("PRAGMA foreign_keys = ON;");
        await db.execute("PRAGMA auto_vacuum = ON;");
        await db.execute("PRAGMA journal_mode = WAL;");
      },
    );
  }

  // Create tables and trigger when database is first created
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Patients (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Full_Name TEXT UNIQUE,
        Phone_Number TEXT DEFAULT NULL,
        Age INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Appointments (
        Patient_id INTEGER,
        Date TEXT DEFAULT (DATETIME('now','localtime')),
        FOREIGN KEY (Patient_id) REFERENCES Patients(Id)
        ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
    await db.execute('''
  CREATE TABLE Treatments (
    Patient_id INTEGER,
    Diagnosis TEXT DEFAULT 'No diagnosis yet',
    Treatment TEXT DEFAULT 'No treatment yet',
    FOREIGN KEY (Patient_id) REFERENCES Patients(Id)
    ON DELETE CASCADE ON UPDATE CASCADE
  )
''');

    // Trigger to auto-create Appointment and Treatment rows when adding a new patient
    await db.execute('''
  CREATE TRIGGER id_trigger
  AFTER INSERT ON Patients
  FOR EACH ROW
  BEGIN
    INSERT INTO Appointments(Patient_id) VALUES (NEW.Id);
    INSERT INTO Treatments(Patient_id, Diagnosis, Treatment) 
    VALUES (NEW.Id, 'No diagnosis yet', 'No treatment yet');
  END;
''');

    await db.execute('CREATE INDEX idx_name ON Patients(Full_Name);');
  }

  // Add a new patient
  Future<int> addPatient(String name, String phone, int age) async {
    final dbClient = await db;
    return await dbClient.insert('Patients', {
      'Full_Name': name,
      'Phone_Number': phone,
      'Age': age,
    });
  }

  // Update patient name
  Future<void> updatePatientName(String oldName, String newName) async {
    final dbClient = await db;
    await dbClient.update('Patients', {'Full_Name': newName},
        where: 'Full_Name = ?', whereArgs: [oldName]);
  }

  // Update patient phone number
  Future<void> updatePhone(String name, String newPhone) async {
    final dbClient = await db;
    await dbClient.update('Patients', {'Phone_Number': newPhone},
        where: 'Full_Name = ?', whereArgs: [name]);
  }

  // Update patient age
  Future<void> updateAge(int oldAge, int newAge) async {
    final dbClient = await db;
    await dbClient.update('Patients', {'Age': newAge},
        where: 'Age = ?', whereArgs: [oldAge]);
  }

  // Update patient's appointment date
  Future<void> updateAppointmentDate(String name, String newDate) async {
    final dbClient = await db;
    final id = await _getPatientIdByName(name);
    await dbClient.update('Appointments', {'Date': newDate},
        where: 'Patient_id = ?', whereArgs: [id]);
  }

  // Update patient's diagnosis
  Future<void> updateDiagnosis(String name, String diagnosis) async {
    final dbClient = await db;
    final id = await _getPatientIdByName(name);
    await dbClient.update('Treatments', {'Diagnosis': diagnosis},
        where: 'Patient_id = ?', whereArgs: [id]);
  }

  Future<void> updateTreatment(String name, String treatment) async {
    final dbClient = await db;
    final id = await _getPatientIdByName(name);
    await dbClient.update('Treatments', {'Treatment': treatment},
        where: 'Patient_id = ?', whereArgs: [id]);
  }

  // Search patient details using part of the name (for search feature)
  Future<List<Map<String, dynamic>>> searchPatientByName(String name) async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
      SELECT Patients.id, Patients.Full_Name, Patients.Phone_Number, Patients.Age,
             Appointments.Date, Treatments.Diagnosis, Treatments.Treatment
      FROM Patients
      LEFT JOIN Appointments ON Patients.Id = Appointments.Patient_id
      LEFT JOIN Treatments ON Patients.Id = Treatments.Patient_id
      WHERE Patients.Full_Name LIKE ?
      ORDER BY Appointments.Date
    ''', ['%$name%']);
  }

  // Delete patient and cascade to Appointments and Treatments
  Future<void> deletePatient(String name) async {
    final dbClient = await db;
    await dbClient
        .delete('Patients', where: 'Full_Name = ?', whereArgs: [name]);
  }

  // Internal method to fetch Patient ID from name
  Future<int?> _getPatientIdByName(String name) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'Patients',
      columns: ['Id'],
      where: 'Full_Name = ?',
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      return result.first['Id'] as int;
    }
    return null;
  }

  // Get all patient details without name filtering
  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
      SELECT 
        Patients.id, 
        Patients.Full_Name, 
        Patients.Phone_Number,
        Patients.Age, 
        Appointments.Date, 
        Treatments.Diagnosis, 
        Treatments.Treatment
      FROM Patients
      LEFT JOIN Appointments ON Patients.Id = Appointments.Patient_id
      LEFT JOIN Treatments ON Patients.Id = Treatments.Patient_id
      ORDER BY Appointments.Date
    ''');
  }
}
