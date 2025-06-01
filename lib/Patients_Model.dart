class Patient {
  final int id;
  final String fullName;
  final String phoneNumber;
  final int age;
  final String appointmentDate;
  final String diagnosis;
  final String treatment;

  Patient({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    required this.appointmentDate,
    required this.diagnosis,
    required this.treatment,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? 0,
      fullName: map['Full_Name'] ?? 'Unknown',
      phoneNumber: map['Phone_Number'] ?? 'Not provided',
      age: map['Age'] ?? 0,
      appointmentDate: map['Date'] ?? 'No appointment',
      diagnosis: map['Diagnosis'] ?? 'No diagnosis yet',
      treatment: map['Treatment'] ?? 'No treatment yet',
    );
  }
}