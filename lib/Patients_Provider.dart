import 'package:flutter/material.dart';
import 'package:projet_8016586/Patients_Model.dart';
import 'data_helper.dart';
// import the model you created

class PatientProvider with ChangeNotifier {
  final DataHelper _dataHelper = DataHelper();
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  // Load all patients that match a name (use '' to load all)
 Future<void> fetchPatients({String nameQuery = ''}) async {
  final data = await _dataHelper.searchPatientByName(nameQuery);
  _patients = data.map((e) => Patient.fromMap(e)).toList();
  notifyListeners();
}

// When saving new patients, ensure all fields have values:
Future<void> addPatient(String name, String phone, int age) async {
  if (name.isEmpty) name = 'Unknown';
  if (phone.isEmpty) phone = 'Not provided';
  await _dataHelper.addPatient(name, phone, age);
  await fetchPatients();
}

  // Update patient info
  Future<void> updatePatient({
    required String oldName,
    String? newName,
    String? newPhone,
    int? newAge,
  }) async {
    if (newName != null) {
      await _dataHelper.updatePatientName(oldName, newName);
    }
    if (newPhone != null) {
      await _dataHelper.updatePhone(
          newPhone, newPhone); // or use oldPhone if tracking it
    }
    if (newAge != null) {
      await _dataHelper.updateAge(
          newAge, newAge); // or pass oldAge if tracking it
    }
    await fetchPatients();
  }

  // Delete patient
  Future<void> deletePatient(String name) async {
    await _dataHelper.deletePatient(name);
    await fetchPatients();
  }

  // Update diagnosis and treatment
  Future<void> updateDiagnosis(
      String name, String diagnosis) async {
    await _dataHelper.updateDiagnosis(name, diagnosis);
    
    await fetchPatients();
  }
    Future<void> updateTreatment(
      String name, String traitement) async {
    await _dataHelper.updateTreatment(name, traitement);
    
    await fetchPatients();
  }

  // Update appointment date
  Future<void> updateAppointment(String name, String date) async {
    await _dataHelper.updateAppointmentDate(name, date);
    await fetchPatients();
  }
}
